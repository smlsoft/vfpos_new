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
import 'package:intl/intl.dart';

void syncProductBarcode(List<ItemRemoveModel> removeList, List<SyncProductBarcodeModel> newDataList) {
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
    global.syncTimeIntervalSecond = 1;
    manyForDelete.add(newData.guidfixed);
    ProductBarcodeObjectBoxStruct newBarcode = ProductBarcodeObjectBoxStruct(
      guid_fixed: newData.guidfixed,
      names: jsonEncode(newData.names),
      name_all: (newData.names).map((e) => e.name).toList().join(" ").toString(),
      product_count: 0,
      barcode: newData.barcode,
      item_guid: "",
      descriptions: "",
      item_code: newData.itemcode,
      item_unit_code: newData.itemunitcode,
      unit_names: jsonEncode(newData.itemunitnames),
      prices: (newData.prices == null) ? "" : jsonEncode(newData.prices!),
      new_line: 0,
      unit_code: newData.itemunitcode,
      options_json: jsonEncode(newData.options),
      images_url: newData.imageuri,
      image_or_color: newData.useimageorcolor,
      color_select: newData.colorselect,
      vat_type: 1,
      isalacarte: newData.isalacarte!,
      is_except_vat: (newData.vatcal == 1) ? true : false,
      ordertypes: (newData.ordertypes == null) ? "" : jsonEncode(newData.ordertypes!),
      color_select_hex: newData.colorselecthex,
      issplitunitprint: newData.issplitunitprint,
    );
    newBarcode.image_or_color = true;

    manyForInsert.add(newBarcode);
    global.syncRefreshProductBarcode = true;
    // Update ข้อมูลใน Memory
    for (int index = 0; index < global.productCategoryCodeSelected.length; index++) {
      if (global.productCategoryCodeSelected[index].guid_fixed == newData.guidfixed) {
        global.productCategoryCodeSelected[index].names = jsonEncode(newData.names);
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

Future<void> syncProductBarcodeCompare(List<SyncMasterStatusModel> masterStatus) async {
  // Sync Barcode
  ApiRepository apiRepository = ApiRepository();
  String lastUpdateTime = global.appStorage.read(global.syncProductBarcodeTimeName) ?? global.syncDateBegin;
  if (ProductBarcodeHelper().count() == 0) {
    lastUpdateTime = global.syncDateBegin;
  }
  lastUpdateTime = DateFormat(global.dateFormatSync).format(DateTime.parse(lastUpdateTime));
  var getLastUpdateTime = global.syncFindLastUpdate(masterStatus, "productbarcode");
  if (lastUpdateTime != getLastUpdateTime) {
    var loop = true;
    var offset = 0;
    var limit = 10000;
    while (loop) {
      await apiRepository.serverProductBarcode(offset: offset, limit: limit, lastupdate: lastUpdateTime).then((value) {
        if (value.success) {
          var dataList = value.data["productbarcode"];
          List<ItemRemoveModel> removeList = (dataList["remove"] as List).map((removeCate) => ItemRemoveModel.fromJson(removeCate)).toList();
          List<SyncProductBarcodeModel> newDataList = (dataList["new"] as List).map((newCate) => SyncProductBarcodeModel.fromJson(newCate)).toList();
          if (newDataList.isEmpty && removeList.isEmpty) {
            loop = false;
          } else {
            syncProductBarcode(removeList, newDataList);
          }
        } else {
          serviceLocator<Log>().debug("************************************************* Error");
          loop = false;
        }
      });
      offset += limit;
    }
    global.appStorage.write(global.syncProductBarcodeTimeName, getLastUpdateTime);
    global.rebuildProductBarcodeStatus = true;
  }
}
