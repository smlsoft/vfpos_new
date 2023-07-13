import 'dart:async';
import 'package:dedepos/api/api_repository.dart';
import 'package:dedepos/api/sync/model/sync_buffet_mode_model.dart';
import 'package:dedepos/api/sync/model/sync_table_model.dart';
import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/db/buffet_mode_helper.dart';
import 'package:dedepos/db/employee_helper.dart';
import 'package:dedepos/api/sync/model/sync_employee_model.dart';
import 'package:dedepos/api/sync/model/item_remove_model.dart';
import 'package:dedepos/db/table_helper.dart';
import 'package:dedepos/db/table_process_helper.dart';
import 'package:dedepos/model/objectbox/buffet_mode_struct.dart';
import 'package:dedepos/model/objectbox/employees_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/objectbox/table_struct.dart';
import 'package:intl/intl.dart';

Future syncBuffetMode(List<ItemRemoveModel> removeList,
    List<SyncBuffetModeModel> newDataList) async {
  List<String> removeMany = [];
  List<BuffetModeObjectBoxStruct> manyForInsert = [];

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

    BuffetModeObjectBoxStruct newBuffetMode = BuffetModeObjectBoxStruct(
      guid_fixed: newData.guidfixed,
      code: newData.code,
      names: [newData.names[0].name],
      adult_price: newData.prices[0].price,
      child_price: newData.prices[1].price,
      max_minute: 120,
    );
    manyForInsert.add(newBuffetMode);
  }
  if (removeMany.isNotEmpty) {
    BuffetModeHelper().deleteByGuidFixedMany(removeMany);
  }
  if (manyForInsert.isNotEmpty) {
    BuffetModeHelper().insertMany(manyForInsert);
  }
}

Future<void> syncBuffetModeCompare(
    List<SyncMasterStatusModel> masterStatus) async {
  ApiRepository apiRepository = ApiRepository();

  // Sync ประเภทการขาย (Buffet Mode)
  String lastUpdateTime =
      global.appStorage.read(global.syncBuffetModeTimeName) ??
          global.syncDateBegin;
  if (BuffetModeHelper().count() == 0) {
    lastUpdateTime = global.syncDateBegin;
  }
  lastUpdateTime =
      DateFormat(global.dateFormatSync).format(DateTime.parse(lastUpdateTime));
  var getLastUpdateTime = global.syncFindLastUpdate(masterStatus, "ordertype");
  if (lastUpdateTime != getLastUpdateTime) {
    var loop = true;
    var offset = 0;
    var limit = 10000;
    while (loop) {
      await apiRepository
          .serverOrderTypeGetData(
              offset: offset, limit: limit, lastupdate: lastUpdateTime)
          .then((value) {
        if (value.success) {
          var dataList = value.data["ordertype"];
          List<ItemRemoveModel> removeList = (dataList["remove"] as List)
              .map((removeCate) => ItemRemoveModel.fromJson(removeCate))
              .toList();
          List<SyncBuffetModeModel> newDataList = (dataList["new"] as List)
              .map((newCate) => SyncBuffetModeModel.fromJson(newCate))
              .toList();
          if (newDataList.isEmpty && removeList.isEmpty) {
            loop = false;
          } else {
            syncBuffetMode(removeList, newDataList);
          }
        } else {
          serviceLocator<Log>()
              .error("************************************************* Error");
          loop = false;
        }
      });
      offset += limit;
    }
    global.appStorage.write(global.syncBuffetModeTimeName, getLastUpdateTime);
  }
}
