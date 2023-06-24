import 'dart:async';
import 'package:dedepos/api/client.dart';
import 'package:dedepos/api/api_repository.dart';
import 'package:dedepos/api/sync/master/sync_bank.dart';
import 'package:dedepos/api/sync/master/sync_employee.dart';
import 'package:dedepos/api/sync/master/sync_product_barcode.dart';
import 'package:dedepos/api/sync/master/sync_product_category.dart';
import 'package:dedepos/api/sync/master/sync_table.dart';
import 'package:dedepos/api/user_repository.dart';
import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/db/product_barcode_helper.dart';
import 'package:dedepos/db/product_category_helper.dart';
import 'package:dedepos/api/sync/model/sync_inventory_model.dart';
import 'package:dedepos/api/sync/model/item_remove_model.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart';
import 'package:intl/intl.dart';

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

Future syncMasterData() async {
  ApiRepository apiRepository = ApiRepository();
  global.syncDataProcess = true;
  try {
    List<SyncMasterStatusModel> masterStatus =
        await apiRepository.serverMasterStatus();
    await syncProductCategoryCompare(masterStatus);
    await syncProductBarcodeCompare(masterStatus);
    await syncEmployeeCompare(masterStatus);
    await syncBankCompare(masterStatus);
    await syncTableCompare(masterStatus);
    global.syncDataSuccess = true;
    global.syncDataProcess = false;
  } catch (e) {
    global.syncDataProcess = false;
  }
}

Future syncMasterProcess() async {
  if (global.appMode == global.AppModeEnum.posTerminal) {
    // Sync เฉพาะเครื่อง POS Terminal
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
      }
      if (global.apiConnected == true &&
          global.loginSuccess == true &&
          global.syncDataProcess == false) {
        syncMasterData();
      }
    }
  }
}
