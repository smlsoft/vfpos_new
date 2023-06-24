import 'dart:async';
import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/db/printer_helper.dart';
import 'package:dedepos/api/sync/model/sync_printer_model.dart';
import 'package:dedepos/api/sync/model/item_remove_model.dart';
import 'package:dedepos/model/objectbox/printer_struct.dart';
import 'package:dedepos/global.dart' as global;

Future syncPrinter(data) async {
  List<String> manyForDelete = [];
  List<PrinterObjectBoxStruct> manyForInsert = [];

  // Delete
  List<ItemRemoveModel> removes = (data["remove"] as List)
      .map((removeCate) => ItemRemoveModel.fromJson(removeCate))
      .toList();
  for (var removeData in removes) {
    try {
      global.syncTimeIntervalSecond = 1;
      manyForDelete.add(removeData.guidfixed);
      global.syncRefreshPrinter = true;
    } catch (e) {
      serviceLocator<Log>().error(e);
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
