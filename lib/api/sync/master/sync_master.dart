import 'dart:async';
import 'package:dedepos/api/api_repository.dart';
import 'package:dedepos/api/sync/master/sync_bank.dart';
import 'package:dedepos/api/sync/master/sync_buffet_mode.dart';
import 'package:dedepos/api/sync/master/sync_kitchen.dart';
import 'package:dedepos/api/sync/master/sync_product_barcode.dart';
import 'package:dedepos/api/sync/master/sync_product_category.dart';
import 'package:dedepos/api/sync/master/sync_table.dart';
import 'package:dedepos/db/product_barcode_status_helper.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/objectbox/product_barcode_status_struct.dart';
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';
import 'package:dedepos/objectbox.g.dart';

Future<void> syncMasterData() async {
  ApiRepository apiRepository = ApiRepository();
  global.syncDataProcess = true;
  try {
    List<SyncMasterStatusModel> masterStatus = await apiRepository.serverMasterStatus();
    await syncProductCategoryCompare(masterStatus);
    await syncProductBarcodeCompare(masterStatus);
    await syncBankCompare(masterStatus);
    await syncTableCompare(masterStatus);
    await syncBuffetModeCompare(masterStatus);
    await syncKitchenCompare(masterStatus);
    global.syncDataSuccess = true;
    global.syncDataProcess = false;
    if (1 == 1) {
      if (global.rebuildProductBarcodeStatus) {
        global.rebuildProductBarcodeStatus = false;
        // กรณีเป็นระบบร้านอาหาร จะทำการสร้าง ProductBarcodeStatusObjectBoxStruct
        List<ProductBarcodeObjectBoxStruct> productBarcode =
            global.objectBoxStore.box<ProductBarcodeObjectBoxStruct>().query(ProductBarcodeObjectBoxStruct_.isalacarte.equals(true)).build().find();
        List<ProductBarcodeStatusObjectBoxStruct> productBarcodeStatus = ProductBarcodeStatusHelper().getAll();
        List<ProductBarcodeStatusObjectBoxStruct> productBarcodeStatusInsertMany = [];
        // ค้นหา ถ้าไม่มีให้เพิ่ม
        for (ProductBarcodeObjectBoxStruct productBarcodeItem in productBarcode) {
          bool found = false;
          // find
          for (ProductBarcodeStatusObjectBoxStruct productBarcodeStatusItem in productBarcodeStatus) {
            if (productBarcodeItem.barcode == productBarcodeStatusItem.barcode) {
              found = true;
              break;
            }
          }
          if (found == false) {
            productBarcodeStatusInsertMany.add(ProductBarcodeStatusObjectBoxStruct(
                barcode: productBarcodeItem.barcode, qtyBalance: 0, orderAutoStock: false, qtyMin: 0, orderDisable: false, qtyStart: 0, orderStatus: 0));
          }
        }
        if (productBarcodeStatusInsertMany.isNotEmpty) {
          ProductBarcodeStatusHelper().insertMany(productBarcodeStatusInsertMany);
        }
      }
    }
  } catch (e) {
    global.syncDataProcess = false;
  }
}

Future syncMasterProcess() async {
  if (global.appMode == global.AppModeEnum.posTerminal) {
    // Sync เฉพาะเครื่อง POS Terminal
    global.isOnline = await global.hasNetwork();
    if (global.isOnline) {
      /*if (global.apiConnected == false) {
        if (global.loginProcess == false) {
          global.loginProcess = true;
          UserRepository userRepository = UserRepository();
          await userRepository
              .authenUser(global.apiUserName, global.apiUserPassword)
              .then((result) async {
            if (result.success) {
              global.apiConnected = true;
              global.appStorage.write("token", result.data["token"]);
              serviceLocator<Log>().debug("Login Success");
              ApiResponse selectShop =
                  await userRepository.selectShop(global.apiShopID);
              if (selectShop.success) {
                serviceLocator<Log>().debug("Select Shop Success");
                global.loginSuccess = true;
              }
            }
          }).catchError((e) {
            serviceLocator<Log>().error(e);
          }).whenComplete(() async {
            global.loginProcess = false;
          });
        }
      }*/
      if (global.apiConnected == true && global.loginSuccess == true && global.syncDataProcess == false) {
        print("---- Start Sync ---");
        syncMasterData();
        print("---- Stop Sync ---");
      }
    }
  }
}
