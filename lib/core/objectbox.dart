import 'dart:io';
import 'dart:developer' as dev;
import 'package:dedepos/db/buffet_mode_helper.dart';
import 'package:dedepos/global.dart';
import 'package:dedepos/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

import '../model/objectbox/buffet_mode_struct.dart';

void createTestDatabase() {
  BuffetModeHelper helper = BuffetModeHelper();
  List<BuffetModeObjectBoxStruct> values = [];
  values.add(BuffetModeObjectBoxStruct(
      code: "pig".toUpperCase(),
      names: ["บุฟเฟ่ต์หมู"],
      adultPrice: 199,
      childPrice: 99,
      maxMinute: 120));
  values.add(BuffetModeObjectBoxStruct(
      code: "meet".toUpperCase(),
      names: ["บุฟเฟ่ต์เนื้อ"],
      adultPrice: 199,
      childPrice: 99,
      maxMinute: 120));
  values.add(BuffetModeObjectBoxStruct(
      code: "seafood".toUpperCase(),
      names: ["บุฟเฟ่ต์ทะเล"],
      adultPrice: 199,
      childPrice: 99,
      maxMinute: 120));
  values.add(BuffetModeObjectBoxStruct(
      code: "kitchen".toUpperCase(),
      names: ["บุฟเฟ่ต์ไก่"],
      adultPrice: 199,
      childPrice: 99,
      maxMinute: 120));
  helper.insertMany(values);
}

Future<void> setupObjectBox() async {
  final appDirectory = await getApplicationDocumentsDirectory();
  final objectBoxDirectory =
      Directory("${appDirectory.path}/$objectBoxDatabaseName");
  if (!objectBoxDirectory.existsSync()) {
    await objectBoxDirectory.create(recursive: true);
  }
  try {
    final isExists = await objectBoxDirectory.exists();
    if (isExists) {
      // ลบทิ้ง เพิ่มทดสอบใหม่
      // dev.log("ObjectBox Data : $isExists");
      await objectBoxDirectory.delete(recursive: true);
      objectBoxStore = Store(getObjectBoxModel(),
          directory: objectBoxDirectory.path,
          queriesCaseSensitiveDefault: false);
      createTestDatabase();
    } else {
      objectBoxStore = Store(getObjectBoxModel(),
          directory: objectBoxDirectory.path,
          queriesCaseSensitiveDefault: false);
    }
  } catch (e) {
    dev.log("App Data : $appDirectory");
    dev.log(e.toString());
    // โครงสร้างเปลี่ยน เริ่ม Sync ใหม่ทั้งหมด
    final isExists = await objectBoxDirectory.exists();
    if (isExists) {
      dev.log("===??? $isExists");
      await objectBoxDirectory.delete(recursive: true);
    }

    objectBoxStore = Store(getObjectBoxModel(),
        directory: objectBoxDirectory.path,
        queriesCaseSensitiveDefault: false,
        macosApplicationGroup: 'objectbox.demo');
  }
}
