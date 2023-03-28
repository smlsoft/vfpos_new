import 'dart:async';
import '../model/objectbox/config_struct.dart';
import 'package:dedepos/global.dart' as global;

class ConfigHelper {
  final _box = global.objectBoxStore.box<ConfigObjectBoxStruct>();

  int insert(ConfigObjectBoxStruct value) {
    return _box.put(value);
  }

  List<ConfigObjectBoxStruct> select() {
    return (_box.query()).build().find();
  }

  void update(ConfigObjectBoxStruct value) async {
    removeAll();
    _box.put(value);
  }

  void removeAll() async {
    await _box.removeAll();
  }
}
