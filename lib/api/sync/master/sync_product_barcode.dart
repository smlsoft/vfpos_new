import 'dart:convert';
import 'package:dedepos/api/api_repository.dart';
import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/db/product_barcode_helper.dart';
import 'package:dedepos/api/sync/model/sync_inventory_model.dart';
import 'package:dedepos/api/sync/model/item_remove_model.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/json/product_option_model.dart';
import 'package:intl/intl.dart';

void syncProductBarcode(List<ItemRemoveModel> removeList,
    List<SyncProductBarcodeModel> newDataList) {
  List<String> manyForDelete = [];
  List<ProductBarcodeObjectBoxStruct> manyForInsert = [];

  // Delete
  for (var removeData in removeList) {
    //print("Remove Product Barcode : " + removeData.guidfixed);
    try {
      global.syncTimeIntervalSecond = 1;
      manyForDelete.add(removeData.guidfixed);
      global.syncRefreshProductBarcode = true;
    } catch (e) {
      serviceLocator<Log>().error(e);
    }
  }
  // Insert
  for (var newData in newDataList) {
    //print("Insert Product Barcode : " + newData.barcode);
    global.syncTimeIntervalSecond = 1;
    manyForDelete.add(newData.guidfixed);
    List<String> packNameValues = [];
    List<String> packUnitNameValues = [];
    List<String> packPriceValues = [];
    String nameAll = "";
    for (int index = 0; index < newData.names.length; index++) {
      packNameValues.add(newData.names[index].name);
      nameAll += "${newData.names[index].name},";
    }
    for (int index = 0; index < newData.itemunitnames.length; index++) {
      packUnitNameValues.add(newData.itemunitnames[index].name);
    }

    // 0=ราคาทั่วไป,1=ราคาสมาชิก
    for (int index = 0; index < newData.prices!.length; index++) {
      packPriceValues.add(newData.prices![index].price.toString());
    }
    String optionsJson = "";
    if (newData.options != null) {
      for (SyncProductOptionModel option in newData.options!) {
        List<String> packOptionNames = [];
        for (int index = 0; index < option.names.length; index++) {
          packOptionNames.add(option.names[index].name);
        }
        ProductOptionModel newOption = ProductOptionModel(
          guid_fixed: option.guid,
          choice_type: option.choicetype,
          max_select: (option.choicetype != 0) ? 1 : option.maxselect,
          names: packOptionNames,
          choices: [],
        );
        for (SyncProductChoiceModel choice in option.choices) {
          List<String> packChoiceNames = [];
          for (int index = 0; index < choice.names.length; index++) {
            packChoiceNames.add(choice.names[index].name);
          }
          ProductChoiceModel newChoice = ProductChoiceModel(
            guid_fixed: choice.guid,
            guid_code: option.guid,
            names: packChoiceNames,
            product_code: choice.refproductcode,
            barcode: choice.refbarcode,
            is_default: choice.isdefault,
            item_unit_code: choice.refunitcode,
            price: choice.price,
            qty: choice.qty,
            selected: false,
          );
          newOption.choices.add(newChoice);
        }
        if (optionsJson != "") {
          optionsJson += ",";
        }
        optionsJson += jsonEncode(newOption.toJson());
      }
    }
    optionsJson = "[$optionsJson]";
    ProductBarcodeObjectBoxStruct newBarcode = ProductBarcodeObjectBoxStruct(
      guid_fixed: newData.guidfixed,
      names: packNameValues,
      name_all: nameAll,
      product_count: 0,
      barcode: newData.barcode,
      item_guid: "",
      descriptions: [],
      item_code: newData.itemcode,
      item_unit_code: newData.itemunitcode,
      unit_names: packUnitNameValues,
      prices: packPriceValues,
      new_line: 0,
      unit_code: newData.itemunitcode,
      options_json: optionsJson,
      images_url: newData.imageuri,
      image_or_color: newData.useimageorcolor,
      color_select: newData.colorselect,
      color_select_hex: newData.colorselecthex,
    );
    // newBarcode.images_url = global.getImageForTest();
    newBarcode.image_or_color = true;

    manyForInsert.add(newBarcode);
    global.syncRefreshProductBarcode = true;
    // Update ข้อมูลใน Memory
    for (int index = 0;
        index < global.productCategoryCodeSelected.length;
        index++) {
      if (global.productCategoryCodeSelected[index].guid_fixed ==
          newData.guidfixed) {
        global.productCategoryCodeSelected[index].names
            .add(newData.names[0].name);
        global.productCategoryCodeSelected[index].image_url = newData.imageuri;

        /*global.productGroupCodeSelected[_index].xorder =
            newData.xsorts![0].xorder;
        global.productGroupCodeSelected[_index].parent_group_guid =
            newData.parentguid;*/
        break;
      }
    }
    global.syncRefreshProductBarcode = true;
  }
  if (manyForDelete.isNotEmpty) {
    ProductBarcodeHelper().deleteByGuidFixedMany(manyForDelete);
  }
  if (manyForInsert.isNotEmpty) {
    ProductBarcodeHelper().insertMany(manyForInsert);
  }
  // Update Count Group
  /*final box = global.objectBoxStore.box<ProductBarcodeObjectBoxStruct>();
  List<ProductBarcodeObjectBoxStruct> selectGroup = box.getAll();
  for (var group in selectGroup) {
    final count = box
        .query(ProductBarcodeObjectBoxStruct_.parent_group_guid
            .equals(group.item_code))
        .build()
        .count();
    if (count > 0) {
      group.group_count = count;
      box.put(group);
    }
  }*/
}

Future<void> syncProductBarcodeCompare(
    List<SyncMasterStatusModel> masterStatus) async {
  // Sync Barcode
  ApiRepository apiRepository = ApiRepository();
  String lastUpdateTime =
      global.appStorage.read(global.syncProductBarcodeTimeName) ??
          global.syncDateBegin;
  if (ProductBarcodeHelper().count() == 0) {
    lastUpdateTime = global.syncDateBegin;
  }
  lastUpdateTime =
      DateFormat(global.dateFormatSync).format(DateTime.parse(lastUpdateTime));
  var getLastUpdateTime =
      global.syncFindLastUpdate(masterStatus, "productbarcode");
  if (lastUpdateTime != getLastUpdateTime) {
    var loop = true;
    var offset = 0;
    var limit = 10000;
    while (loop) {
      await apiRepository
          .serverProductBarcode(
              offset: offset, limit: limit, lastupdate: lastUpdateTime)
          .then((value) {
        if (value.success) {
          var dataList = value.data["productbarcode"];
          List<ItemRemoveModel> removeList = (dataList["remove"] as List)
              .map((removeCate) => ItemRemoveModel.fromJson(removeCate))
              .toList();
          List<SyncProductBarcodeModel> newDataList = (dataList["new"] as List)
              .map((newCate) => SyncProductBarcodeModel.fromJson(newCate))
              .toList();
          serviceLocator<Log>().debug(
              "offset : $offset remove : ${removeList.length} insert : ${newDataList.length}");
          if (newDataList.isEmpty && removeList.isEmpty) {
            loop = false;
          } else {
            syncProductBarcode(removeList, newDataList);
          }
        } else {
          serviceLocator<Log>()
              .debug("************************************************* Error");
          loop = false;
        }
      });
      offset += limit;
    }
    serviceLocator<Log>().debug(
        "Update syncProductBarcodeTimeName Success : ${ProductBarcodeHelper().count()}");
    global.appStorage
        .write(global.syncProductBarcodeTimeName, getLastUpdateTime);
  }
}
