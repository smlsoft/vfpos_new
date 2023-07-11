import 'dart:async';
import 'dart:convert';
import 'package:dedepos/api/api_repository.dart';
import 'package:dedepos/api/sync/model/sync_table_model.dart';
import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/db/employee_helper.dart';
import 'package:dedepos/api/sync/model/sync_employee_model.dart';
import 'package:dedepos/api/sync/model/item_remove_model.dart';
import 'package:dedepos/db/table_helper.dart';
import 'package:dedepos/db/table_process_helper.dart';
import 'package:dedepos/model/objectbox/employees_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/objectbox/table_struct.dart';
import 'package:intl/intl.dart';

Future syncTable(
    List<ItemRemoveModel> removeList, List<SyncTableModel> newDataList) async {
  List<String> removeMany = [];
  List<TableObjectBoxStruct> manyForInsert = [];

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

    TableObjectBoxStruct newTable = TableObjectBoxStruct(
      guidfixed: newData.guidfixed,
      number: newData.number,
      names: jsonEncode(newData.names),
      zone: newData.zone,
    );
    manyForInsert.add(newTable);
  }
  if (removeMany.isNotEmpty) {
    TableHelper().deleteByGuidFixedMany(removeMany);
  }
  if (manyForInsert.isNotEmpty) {
    TableHelper().insertMany(manyForInsert);
  }
}

Future<void> syncTableCompare(List<SyncMasterStatusModel> masterStatus) async {
  ApiRepository apiRepository = ApiRepository();

  // Sync Table
  String lastUpdateTime =
      global.appStorage.read(global.syncTableTimeName) ?? global.syncDateBegin;
  if (TableHelper().count() == 0) {
    lastUpdateTime = global.syncDateBegin;
  }
  lastUpdateTime =
      DateFormat(global.dateFormatSync).format(DateTime.parse(lastUpdateTime));
  var getLastUpdateTime =
      global.syncFindLastUpdate(masterStatus, "restaurant-table");
  if (lastUpdateTime != getLastUpdateTime) {
    var loop = true;
    var offset = 0;
    var limit = 10000;
    while (loop) {
      await apiRepository
          .serverTableGetData(
              offset: offset, limit: limit, lastupdate: lastUpdateTime)
          .then((value) {
        if (value.success) {
          var dataList = value.data["restaurant-table"];
          List<ItemRemoveModel> removeList = (dataList["remove"] as List)
              .map((removeCate) => ItemRemoveModel.fromJson(removeCate))
              .toList();
          List<SyncTableModel> newDataList = (dataList["new"] as List)
              .map((newCate) => SyncTableModel.fromJson(newCate))
              .toList();
          if (newDataList.isEmpty && removeList.isEmpty) {
            loop = false;
          } else {
            syncTable(removeList, newDataList);
          }
        } else {
          serviceLocator<Log>()
              .error("************************************************* Error");
          loop = false;
        }
      });
      offset += limit;
    }
    global.appStorage.write(global.syncTableTimeName, getLastUpdateTime);
    // เพิ่มโต็ะไว้ที่ Table Process ด้วย
    var tableList = TableHelper().getAll();
    for (var table in tableList) {
      // find old table
      var oldTable = TableProcessHelper().getByTableNumber(table.number);
      if (oldTable == null) {
        TableProcessHelper().insert(TableProcessObjectBoxStruct(
          guidfixed: table.guidfixed,
          number: table.number,
          names: table.names,
          zone: table.zone,
          table_status: 0,
          order_count: 0,
          amount: 0,
          order_success: true,
          qr_code: "",
          man_count: 0,
          woman_count: 0,
          child_count: 0,
          table_al_la_crate_mode: true,
          buffet_code: "",
          table_open_datetime: DateTime.now(),
          customer_code_or_telephone: "",
          customer_name: "",
          customer_address: "",
          delivery_code: "",
          delivery_number: "",
          delivery_ticket_number: "",
          remark: "",
          open_by_staff_code: "",
          make_food_immediately: true,
          is_delivery: false,
          delivery_cook_success: false,
          delivery_cook_success_datetime: DateTime.now(),
          delivery_send_success: false,
          delivery_send_success_datetime: DateTime.now(),
          delivery_status: 0,
        ));
      }
    }
  }
}
