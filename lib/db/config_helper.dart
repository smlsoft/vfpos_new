import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/config_struct.dart';

class ConfigHelper {
  final box = global.objectBoxStore.box<ConfigObjectBoxStruct>();

  int insert(ConfigObjectBoxStruct value) {
    return box.put(value);
  }

  List<ConfigObjectBoxStruct> select() {
    return (box.query()).build().find();
  }

  void update(ConfigObjectBoxStruct value) async {
    removeAll();
    box.put(value);
  }

  void removeAll() async {
    box.removeAll();
  }
}
