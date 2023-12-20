import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/order_temp_struct.dart';
import 'package:dedepos/objectbox.g.dart';

class OrderTempHelper {
  final box = global.objectBoxStore.box<OrderTempObjectBoxStruct>();

  int insert(OrderTempObjectBoxStruct value) {
    return box.put(value);
  }

  void insertMany(List<OrderTempObjectBoxStruct> values) {
    box.putMany(values);
  }

  List<OrderTempObjectBoxStruct> getAll() {
    return (box.query()).build().find();
  }

  List<OrderTempObjectBoxStruct> select({String word = ""}) {
    if (word.trim().isEmpty) {
      return (box.query()).build().find();
    }
    return (box.query()).build().find();
  }

  int count() {
    return (box.query()).build().count();
  }

  void deleteAll() {
    box.removeAll();
  }
}
