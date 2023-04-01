import 'dart:async';
import 'dart:convert';
import 'package:dedepos/api/client.dart';
import 'package:dedepos/api/sync/api/api_repository.dart';
import 'package:dedepos/api/user_repository.dart';
import 'package:dedepos/db/employee_helper.dart';
import 'package:dedepos/db/master_bank_helper.dart';
import 'package:dedepos/db/printer_helper.dart';
import 'package:dedepos/db/product_barcode_helper.dart';
import 'package:dedepos/db/product_category_helper.dart';
import 'package:dedepos/api/sync/model/bank_and_wallet_struct.dart';
import 'package:dedepos/api/sync/model/employee_struct.dart';
import 'package:dedepos/api/sync/model/sync_printer.dart';
import 'package:dedepos/model/objectbox/bank_and_wallet_struct.dart';
import 'package:dedepos/api/sync/model/sync_inventory.dart';
import 'package:dedepos/api/sync/model/item_remove.dart';
import 'package:dedepos/model/objectbox/employees_struct.dart';
import 'package:dedepos/model/objectbox/printer_struct.dart';
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';
import 'package:dedepos/model/objectbox/product_category_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart' as globalModel;
import 'package:dedepos/model/objectbox/product_option.dart';
import 'package:dedepos/objectbox.g.dart';
import 'package:intl/intl.dart';

Future getMaster() async {
  MasterBankHelper helper = MasterBankHelper();
  ApiRepository apiRepository = ApiRepository();
  await apiRepository.getMasterBank().then((result) {
    if (result.success) {
      helper.deleteAll();
      List<ApiBankAndWalletStruct> dataFromApi = (result.data as List)
          .map((newData) => ApiBankAndWalletStruct.fromJson(newData))
          .toList();
      List<BankAndWalletObjectBoxStruct> data = [];
      for (var value in dataFromApi) {
        BankAndWalletObjectBoxStruct newBank = BankAndWalletObjectBoxStruct();
        newBank.paymentcode = value.paymentcode;
        newBank.countrycode = value.countrycode;
        newBank.name1 = value.name1;
        newBank.name2 = value.name2;
        newBank.name3 = value.name3;
        newBank.name4 = value.name4;
        newBank.name5 = value.name5;
        newBank.name5 = value.name5;
        newBank.paymentlogo = value.paymentlogo;
        newBank.paymenttype = value.paymenttype;
        newBank.feeRate = value.feerate;
        newBank.wallettype = value.wallettype;
        data.add(newBank);
      }
      helper.insertMany(data);
    }
  }).catchError((e) {
    print(e.toString());
  });
  global.createLogoImageFromBankProvider();
}

Future syncEmployee(data) async {
  // Delete
  List<ItemRemove> removeMany = (data["remove"] as List)
      .map((removeCate) => ItemRemove.fromJson(removeCate))
      .toList();
  for (var data in removeMany) {
    try {
      global.employeeHelper.deleteByGuidFixed(data.guidfixed);
    } catch (e) {
      print(e);
    }
  }
  // Insert
  List<EmployeeStruct> insert = (data["new"] as List)
      .map((newCate) => EmployeeStruct.fromJson(newCate))
      .toList();
  List<String> manyForDelete = [];
  List<EmployeeObjectBoxStruct> insertManyData = [];
  int count = 100;
  for (var getData in insert) {
    count++;
    //print("Insert Category : " + _data.categoryguid + "/" + _data.name1);
    manyForDelete.add(getData.guidfixed);
    insertManyData.add(EmployeeObjectBoxStruct(
        username: getData.username,
        code: count.toString(), // _data.code,
        profilepicture: getData.profilepicture,
        guidfixed: getData.guidfixed,
        //roles: _data.roles.toString(),
        name: getData.name));
  }
  EmployeeHelper().deleteByGuidFixedMany(manyForDelete);
  EmployeeHelper().insertMany(insertManyData);
}

Future syncProductCategory(data) async {
  List<String> removeMany = [];
  List<ProductCategoryObjectBoxStruct> manyForInsert = [];

  // Delete
  List<ItemRemove> removes = (data["remove"] as List)
      .map((removeCate) => ItemRemove.fromJson(removeCate))
      .toList();
  for (var removeData in removes) {
    try {
      global.syncTimeIntervalSecond = 1;
      removeMany.add(removeData.guidfixed);
      global.syncRefreshProductCategory = true;
    } catch (e) {
      print(e);
    }
  }
  // Insert
  List<SyncCategory> newDataList = (data["new"] as List)
      .map((newCate) => SyncCategory.fromJson(newCate))
      .toList();
  for (var newData in newDataList) {
    global.syncTimeIntervalSecond = 1;
    removeMany.add(newData.guidfixed);

    ProductCategoryObjectBoxStruct newProduct = ProductCategoryObjectBoxStruct(
      guid_fixed: newData.guidfixed,
      parent_guid_fixed: newData.parentguid,
      names: [],
      image_url: newData.imageuri,
      use_image_or_color: newData.useimageorcolor,
      colorselect: newData.colorselect,
      colorselecthex: newData.colorselecthex,
      codelist: jsonEncode(newData.codelist),
      xorder: newData.xsorts![0].xorder,
      category_count: newData.childcount,
    );
    // ทดสอบ รูป
    newProduct.image_url = global.getImageForTest();

    print("Sync Product Category : " +
        newData.guidfixed +
        " " +
        newData.names![0].name +
        " " +
        newData.parentguid);
    newProduct.names.add(newData.names![0].name);
    manyForInsert.add(newProduct);
  }
  if (removeMany.isNotEmpty) {
    global.syncRefreshProductCategory = true;
    ProductCategoryHelper().deleteByGuidFixedMany(removeMany);
  }
  if (manyForInsert.isNotEmpty) {
    global.syncRefreshProductCategory = true;
    ProductCategoryHelper().insertMany(manyForInsert);
  }
  if (global.syncRefreshProductCategory) {
    // Update Count Group
    final box = global.objectBoxStore.box<ProductCategoryObjectBoxStruct>();
    List<ProductCategoryObjectBoxStruct> selectCategory = box.getAll();
    for (var category in selectCategory) {
      final count = box
          .query(ProductCategoryObjectBoxStruct_.parent_guid_fixed
              .equals(category.guid_fixed))
          .build()
          .count();
      if (count > 0) {
        category.category_count = count;
        box.put(category);
      }
    }
  }
}

void syncProductBarcode(
    List<ItemRemove> removeList, List<SyncProductBarcodeModel> newDataList) {
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
      print(e);
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
        ProductOptionStruct newOption = ProductOptionStruct(
          guid_fixed: option.guid,
          choice_type: option.choicetype,
          max_select: option.maxselect,
          names: packOptionNames,
          choices: [],
        );
        for (SyncProductChoiceModel choice in option.choices) {
          List<String> packChoiceNames = [];
          for (int index = 0; index < choice.names.length; index++) {
            packChoiceNames.add(choice.names[index].name);
          }
          ProductChoiceStruct newChoice = ProductChoiceStruct(
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
    newBarcode.images_url = global.getImageForTest();
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

Future syncPrinter(data) async {
  List<String> manyForDelete = [];
  List<PrinterObjectBoxStruct> manyForInsert = [];

  // Delete
  List<ItemRemove> removes = (data["remove"] as List)
      .map((removeCate) => ItemRemove.fromJson(removeCate))
      .toList();
  for (var removeData in removes) {
    try {
      global.syncTimeIntervalSecond = 1;
      manyForDelete.add(removeData.guidfixed);
      global.syncRefreshPrinter = true;
    } catch (e) {
      print(e);
    }
  }
  // Insert
  List<SyncPrinterModel> newDataList = (data["new"] as List)
      .map((newCate) => SyncPrinterModel.fromJson(newCate))
      .toList();
  for (var newData in newDataList) {
    global.syncTimeIntervalSecond = 1;
    manyForDelete.add(newData.guidfixed);
    PrinterObjectBoxStruct newPrinter = PrinterObjectBoxStruct(
      code: newData.code,
      guid_fixed: newData.guidfixed,
      name1: newData.name1,
      type: newData.type,
      print_ip_address: newData.address,
    );
    manyForInsert.add(newPrinter);
    global.syncRefreshPrinter = true;
  }
  if (manyForDelete.isNotEmpty) {
    PrinterHelper().deleteByGuidFixedMany(manyForDelete);
  }
  if (manyForInsert.isNotEmpty) {
    PrinterHelper().insertMany(manyForInsert);
  }
}

/*
flutter: bankmaster 2023-02-14T02:39:48Z
flutter: bookbank 0001-01-01T00:00:00Z
flutter: device 2023-02-14T02:36:53Z
flutter: employee 0001-01-01T00:00:00Z
flutter: kitchen 2023-02-14T02:36:29Z
flutter: member 0001-01-01T00:00:00Z
flutter: printer 2023-02-06T03:37:40Z
flutter: product 0001-01-01T00:00:00Z
flutter: productbarcode 2023-02-14T07:57:02Z
flutter: productcategory 2023-02-14T07:55:01Z
flutter: productunit 2023-02-17T04:14:39Z
flutter: qrpayment 0001-01-01T00:00:00Z
flutter: shoptable 2023-02-14T02:35:51Z
flutter: shopzone 0001-01-01T00:00:00Z
flutter: staff 2023-02-14T02:39:22Z
*/

String syncFindLastUpdate(
    List<globalModel.SyncMasterStatusModel> dataList, String tableName) {
  for (var item in dataList) {
    if (item.tableName == tableName) {
      return DateFormat(global.dateFormatSync)
          .format(DateTime.parse(item.lastUpdate));
    }
  }
  return DateFormat(global.dateFormatSync)
      .format(DateTime.parse(global.syncDateBegin));
}

Future syncMasterData() async {
  String dateBegin = "2000-01-01T00:00:00";
  ApiRepository apiRepository = ApiRepository();

  String lastUpdateTime =
      global.appStorage.read(global.syncCategoryTimeName) ?? dateBegin;
  global.syncDataProcess = true;
  var masterStatus = await apiRepository.serverMasterStatus();
  {
    // หมวดสินค้า
    if (ProductCategoryHelper().count() == 0) {
      lastUpdateTime = global.syncDateBegin;
    }
    lastUpdateTime = DateFormat(global.dateFormatSync)
        .format(DateTime.parse(lastUpdateTime));
    var getLastUpdateTime = syncFindLastUpdate(masterStatus, "productcategory");
    if (lastUpdateTime != getLastUpdateTime) {
      print("serverProductCategory Start");
      await apiRepository
          .serverProductCategory(
              offset: 0, limit: 1000, lastupdate: lastUpdateTime)
          .then((value) {
        if (value.success) {
          syncProductCategory(value.data["productcategory"]).then((_) {
            //print("Update syncCategoryTimeName Success");
            global.appStorage
                .write(global.syncCategoryTimeName, getLastUpdateTime);
          });
        }
      });
      print("serverProductCategory End : " +
          ProductCategoryHelper().count().toString());
    }
  }
  {
    // Sync Barcode
    String lastUpdateTime =
        global.appStorage.read(global.syncProductBarcodeTimeName) ?? dateBegin;
    if (ProductBarcodeHelper().count() == 0) {
      lastUpdateTime = global.syncDateBegin;
    }
    lastUpdateTime = DateFormat(global.dateFormatSync)
        .format(DateTime.parse(lastUpdateTime));
    var getLastUpdateTime = syncFindLastUpdate(masterStatus, "productbarcode");
    if (lastUpdateTime != getLastUpdateTime) {
      print("serverProductBarcode Start");
      // Test
      // lastUpdateTime = global.syncDateBegin;
      //
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
            List<ItemRemove> removeList = (dataList["remove"] as List)
                .map((removeCate) => ItemRemove.fromJson(removeCate))
                .toList();
            List<SyncProductBarcodeModel> newDataList =
                (dataList["new"] as List)
                    .map((newCate) => SyncProductBarcodeModel.fromJson(newCate))
                    .toList();
            print("offset : " +
                offset.toString() +
                " remove : " +
                removeList.length.toString() +
                " insert : " +
                newDataList.length.toString());
            if (newDataList.isEmpty && removeList.isEmpty) {
              loop = false;
            } else {
              syncProductBarcode(removeList, newDataList);
            }
          } else {
            print("************************************************* Error");
            loop = false;
          }
        });
        offset += limit;
      }
      print("Update syncProductBarcodeTimeName Success : " +
          ProductBarcodeHelper().count().toString());
      global.appStorage
          .write(global.syncProductBarcodeTimeName, getLastUpdateTime);
    }
  }
  {
    // Sync Printer
    String lastUpdateTime =
        global.appStorage.read(global.syncPrinterTimeName) ?? dateBegin;
    if (PrinterHelper().count() == 0) {
      lastUpdateTime = global.syncDateBegin;
    }
    lastUpdateTime = DateFormat(global.dateFormatSync)
        .format(DateTime.parse(lastUpdateTime));
    var getLastUpdateTime = syncFindLastUpdate(masterStatus, "printer");
    if (lastUpdateTime != getLastUpdateTime) {
      await apiRepository
          .serverPrinter(offset: 0, limit: 1000, lastupdate: lastUpdateTime)
          .then((value) {
        if (value.success) {
          syncPrinter(value.data["printer"]).then((_) {
            global.appStorage
                .write(global.syncPrinterTimeName, getLastUpdateTime);
          });
        }
      });
    }
  }
  {
    // Sync พนักงาน
    /*String lastUpdateTime =
        global.appStorage.read(global.syncEmployeeTimeName) ?? dateBegin;
    lastUpdateTime = dateBegin;
    if (PrinterHelper().count() == 0) {
      lastUpdateTime = global.syncDateBegin;
    }
    lastUpdateTime = DateFormat(global.dateFormatSync)
        .format(DateTime.parse(lastUpdateTime));
    var getLastUpdateTime = syncFindLastUpdate(masterStatus, "employee");
    if (lastUpdateTime != getLastUpdateTime) {
      await apiRepository
          .serverEmployee(offset: 0, limit: 1000, lastupdate: lastUpdateTime)
          .then((value) {
        if (value.success) {
          syncEmployee(value.data["employee"]).then((_) {
            global.appStorage
                .write(global.syncEmployeeTimeName, getLastUpdateTime);
          });
        }
      });
    }*/
  }
  global.syncDataSuccess = true;
  global.syncDataProcess = false;
}

Future syncMasterProcess() async {
  global.isOnline = await global.hasNetwork();
  if (global.isOnline) {
    if (global.apiConnected == false) {
      if (global.loginProcess == false) {
        global.loginProcess = true;
        UserRepository userRepository = UserRepository();
        await userRepository
            .authenUser(global.apiUserName, global.apiUserPassword)
            .then((result) async {
          if (result.success) {
            global.apiConnected = true;
            global.appStorage.write("token", result.data["token"]);
            print("Login Success");
            ApiResponse selectShop =
                await userRepository.selectShop(global.apiShopID);
            if (selectShop.success) {
              print("Select Shop Success");
              global.loginSuccess = true;
            }
          }
        }).catchError((e) {
          print(e);
        }).whenComplete(() async {
          global.loginProcess = false;
        });
      }
    }
    if (global.apiConnected == true &&
        global.loginSuccess == true &&
        global.syncDataProcess == false) {
      syncMasterData();
    }
  }
}
