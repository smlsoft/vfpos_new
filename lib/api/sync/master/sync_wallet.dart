import 'dart:async';
import 'dart:convert';
import 'package:dedepos/api/api_repository.dart';
import 'package:dedepos/api/sync/model/sync_buffet_mode_model.dart';
import 'package:dedepos/api/sync/model/sync_wallet_model.dart';
import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/db/buffet_mode_helper.dart';
import 'package:dedepos/api/sync/model/item_remove_model.dart';
import 'package:dedepos/db/wallet_helper.dart';
import 'package:dedepos/model/objectbox/buffet_mode_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/objectbox/wallet_struct.dart';
import 'package:intl/intl.dart';

Future syncWallet(List<ItemRemoveModel> removeList, List<SyncWalletModel> newDataList) async {
  List<String> removeMany = [];
  List<WalletObjectBoxStruct> manyForInsert = [];

  // Delete
  for (var removeData in removeList) {
    try {
      global.syncTimeIntervalSecond = 1;
      removeMany.add(removeData.guidfixed);
    } catch (e) {
      serviceLocator<Log>().error(e);
    }
  }
  // Insert
  for (var newData in newDataList) {
    global.syncTimeIntervalSecond = 1;
    removeMany.add(newData.guidfixed);

    WalletObjectBoxStruct newWallet = WalletObjectBoxStruct(
      code: newData.code,
      guid_fixed: newData.guidfixed,
      bookbankcode: newData.bankcode,
      bookbankname: newData.bookbankname,
      countrycode: newData.countrycode,
      feerate: newData.feerate,
      names: jsonEncode(newData.names),
      paymentcode: newData.paymentcode,
      paymenttype: newData.paymenttype,
      wallettype: newData.wallettype,
      paymentlogo: newData.paymentlogo,
    );
    manyForInsert.add(newWallet);
  }
  if (removeMany.isNotEmpty) {
    WalletHelper().deleteByGuidFixedMany(removeMany);
  }
  if (manyForInsert.isNotEmpty) {
    WalletHelper().insertMany(manyForInsert);
  }
}

Future<void> syncWalletCompare(List<SyncMasterStatusModel> masterStatus) async {
  ApiRepository apiRepository = ApiRepository();

  // Sync ประเภทการขาย (Buffet Mode)
  String lastUpdateTime = global.appStorage.read(global.syncWalletTimeName) ?? global.syncDateBegin;
  if (WalletHelper().count() == 0) {
    lastUpdateTime = global.syncDateBegin;
  }
  lastUpdateTime = DateFormat(global.dateFormatSync).format(DateTime.parse(lastUpdateTime));
  var getLastUpdateTime = global.syncFindLastUpdate(masterStatus, "ordertype");
  if (lastUpdateTime != getLastUpdateTime) {
    var loop = true;
    var offset = 0;
    var limit = 10000;
    while (loop) {
      await apiRepository.serverOrderTypeGetData(offset: offset, limit: limit, lastupdate: lastUpdateTime).then((value) {
        if (value.success) {
          var dataList = value.data["ordertype"];
          List<ItemRemoveModel> removeList = (dataList["remove"] as List).map((removeCate) => ItemRemoveModel.fromJson(removeCate)).toList();
          List<SyncWalletModel> newDataList = (dataList["new"] as List).map((newCate) => SyncWalletModel.fromJson(newCate)).toList();
          if (newDataList.isEmpty && removeList.isEmpty) {
            loop = false;
          } else {
            syncWallet(removeList, newDataList);
          }
        } else {
          serviceLocator<Log>().error("************************************************* Error");
          loop = false;
        }
      });
      offset += limit;
    }
    global.appStorage.write(global.syncWalletTimeName, getLastUpdateTime);
  }
}
