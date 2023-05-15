import 'dart:async';
import 'package:dedepos/api/sync/api_repository.dart';
import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/db/employee_helper.dart';
import 'package:dedepos/api/sync/model/sync_employee_model.dart';
import 'package:dedepos/api/sync/model/item_remove_model.dart';
import 'package:dedepos/model/objectbox/employees_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart';
import 'package:intl/intl.dart';

Future syncEmployee(List<ItemRemoveModel> removeList,
    List<SyncEmployeeModel> newDataList) async {
  List<String> removeMany = [];
  List<EmployeeObjectBoxStruct> manyForInsert = [];

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

    EmployeeObjectBoxStruct newEmployee = EmployeeObjectBoxStruct(
      guidfixed: newData.guidfixed,
      code: newData.code,
      email: newData.email,
      is_enabled: newData.isenabled,
      name: newData.name,
      profile_picture: newData.profilepicture,
    );

    serviceLocator<Log>()
        .trace("Sync Employee : ${newData.code} ${newData.name}");
    manyForInsert.add(newEmployee);
  }
  if (removeMany.isNotEmpty) {
    EmployeeHelper().deleteByGuidFixedMany(removeMany);
  }
  if (manyForInsert.isNotEmpty) {
    EmployeeHelper().insertMany(manyForInsert);
  }
}

Future<void> syncEmployeeCompare(
    List<SyncMasterStatusModel> masterStatus) async {
  ApiRepository apiRepository = ApiRepository();

  // Sync พนักงาน
  String lastUpdateTime = global.appStorage.read(global.syncEmployeeTimeName) ??
      global.syncDateBegin;
  if (EmployeeHelper().count() == 0) {
    lastUpdateTime = global.syncDateBegin;
  }
  lastUpdateTime =
      DateFormat(global.dateFormatSync).format(DateTime.parse(lastUpdateTime));
  var getLastUpdateTime = global.syncFindLastUpdate(masterStatus, "employee");
  if (lastUpdateTime != getLastUpdateTime) {
    serviceLocator<Log>().trace("syncEmployee Start");
    var loop = true;
    var offset = 0;
    var limit = 10000;
    while (loop) {
      await apiRepository
          .serverEmployee(
              offset: offset, limit: limit, lastupdate: lastUpdateTime)
          .then((value) {
        if (value.success) {
          var dataList = value.data["employee"];
          List<ItemRemoveModel> removeList = (dataList["remove"] as List)
              .map((removeCate) => ItemRemoveModel.fromJson(removeCate))
              .toList();
          List<SyncEmployeeModel> newDataList = (dataList["new"] as List)
              .map((newCate) => SyncEmployeeModel.fromJson(newCate))
              .toList();
          serviceLocator<Log>().trace(
              "offset : $offset remove : ${removeList.length} insert : ${newDataList.length}");
          if (newDataList.isEmpty && removeList.isEmpty) {
            loop = false;
          } else {
            syncEmployee(removeList, newDataList);
          }
        } else {
          serviceLocator<Log>()
              .error("************************************************* Error");
          loop = false;
        }
      });
      offset += limit;
    }
    serviceLocator<Log>()
        .trace("Update SyncEmployee Success : ${EmployeeHelper().count()}");
    global.appStorage.write(global.syncEmployeeTimeName, getLastUpdateTime);
  }
}
