import 'dart:io';
import 'dart:developer' as dev;
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global.dart';
import 'package:dedepos/model/objectbox/bank_struct.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/model/objectbox/buffet_mode_struct.dart';
import 'package:dedepos/model/objectbox/employees_struct.dart';
import 'package:dedepos/model/objectbox/form_design_struct.dart';
import 'package:dedepos/model/objectbox/kitchen_struct.dart';
import 'package:dedepos/model/objectbox/order_temp_struct.dart';
import 'package:dedepos/model/objectbox/pos_log_struct.dart';
import 'package:dedepos/model/objectbox/pos_ticket_struct.dart';
import 'package:dedepos/model/objectbox/printer_struct.dart';
import 'package:dedepos/model/objectbox/product_barcode_status_struct.dart';
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';
import 'package:dedepos/model/objectbox/product_category_struct.dart';
import 'package:dedepos/model/objectbox/shift_struct.dart';
import 'package:dedepos/model/objectbox/staff_client_struct.dart';
import 'package:dedepos/model/objectbox/table_struct.dart';
import 'package:dedepos/model/objectbox/wallet_struct.dart';
import 'package:dedepos/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

Future<void> objectBoxInit() async {
  final appDirectory = await getApplicationDocumentsDirectory();
  final objectBoxDirectory = Directory("${appDirectory.path}/dedepos/objectbox");
  if (!objectBoxDirectory.existsSync()) {
    await objectBoxDirectory.create(recursive: true);
  }
  try {
    final isExists = await objectBoxDirectory.exists();
    if (isExists) {
      // ลบทิ้ง เพิ่มทดสอบใหม่
      // try {
      //   await objectBoxDirectory.delete(recursive: true);
      // } catch (e) {
      //   dev.log(e.toString());
      // }
      objectBoxStore = Store(getObjectBoxModel(), directory: objectBoxDirectory.path, queriesCaseSensitiveDefault: false);
    } else {
      objectBoxStore = Store(getObjectBoxModel(), directory: objectBoxDirectory.path, queriesCaseSensitiveDefault: false);
    }
  } catch (e) {
    dev.log("App Data : $appDirectory");
    dev.log(e.toString());
    // โครงสร้างเปลี่ยน เริ่ม Sync ใหม่ทั้งหมด
    final isExists = await objectBoxDirectory.exists();
    if (isExists) {
      dev.log("===??? $isExists");
      //  await objectBoxDirectory.delete(recursive: true);
    }

    objectBoxStore = Store(getObjectBoxModel(), directory: objectBoxDirectory.path, queriesCaseSensitiveDefault: false, macosApplicationGroup: 'objectbox.demo');
  }
}

void objectBoxDeleteAll() {
  objectBoxStore.box<BankObjectBoxStruct>().removeAll();
  objectBoxStore.box<BillObjectBoxStruct>().removeAll();
  objectBoxStore.box<BuffetModeObjectBoxStruct>().removeAll();
  objectBoxStore.box<EmployeeObjectBoxStruct>().removeAll();
  objectBoxStore.box<FormDesignObjectBoxStruct>().removeAll();
  objectBoxStore.box<KitchenObjectBoxStruct>().removeAll();
  objectBoxStore.box<OrderTempObjectBoxStruct>().removeAll();
  objectBoxStore.box<PosLogObjectBoxStruct>().removeAll();
  objectBoxStore.box<PosTicketObjectBoxStruct>().removeAll();
  objectBoxStore.box<PrinterObjectBoxStruct>().removeAll();
  objectBoxStore.box<ProductBarcodeStatusObjectBoxStruct>().removeAll();
  objectBoxStore.box<ProductBarcodeObjectBoxStruct>().removeAll();
  objectBoxStore.box<ProductCategoryObjectBoxStruct>().removeAll();
  objectBoxStore.box<ShiftObjectBoxStruct>().removeAll();
  objectBoxStore.box<StaffClientObjectBoxStruct>().removeAll();
  objectBoxStore.box<TableObjectBoxStruct>().removeAll();
  objectBoxStore.box<WalletObjectBoxStruct>().removeAll();

  global.appStorage.remove(global.syncCategoryTimeName);
  global.appStorage.remove(global.syncProductBarcodeTimeName);
  global.appStorage.remove(global.syncInventoryTimeName);
  global.appStorage.remove(global.syncMemberTimeName);
  global.appStorage.remove(global.syncBankTimeName);
  global.appStorage.remove(global.syncTableTimeName);
  global.appStorage.remove(global.syncBuffetModeTimeName);
  global.appStorage.remove(global.syncKitchenTimeName);
  global.appStorage.remove(global.syncWalletTimeName);
}
