import 'dart:io';
import 'dart:developer' as dev;
import 'package:dedepos/db/buffet_mode_helper.dart';
import 'package:dedepos/global.dart';
import 'package:dedepos/model/objectbox/buffet_mode_struct.dart';
import 'package:dedepos/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

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
      // await objectBoxDirectory.delete(recursive: true);
      objectBoxStore = Store(getObjectBoxModel(),
          directory: objectBoxDirectory.path,
          queriesCaseSensitiveDefault: false);
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
