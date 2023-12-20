import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/shift_struct.dart';
import 'package:dedepos/objectbox.g.dart';

class ShiftHelper {
  final box = global.objectBoxStore.box<ShiftObjectBoxStruct>();

  int insert(ShiftObjectBoxStruct value) {
    return box.put(value);
  }

  void insertMany(List<ShiftObjectBoxStruct> values) {
    box.putMany(values);
  }

  bool deleteByGuidFixed(String guid) {
    bool result = false;
    final find = box.query(ShiftObjectBoxStruct_.guidfixed.equals(guid)).build().findFirst();
    if (find != null) {
      result = box.remove(find.id);
    }
    return result;
  }

  List<ShiftObjectBoxStruct> selectSyncIsFalse() {
    return box.query(ShiftObjectBoxStruct_.isSync.equals(false)).build().find();
  }

  void updatesSyncSuccess({required String docNumber}) {
    final find = box.query(ShiftObjectBoxStruct_.guidfixed.equals(docNumber)).build().findFirst();
    if (find != null) {
      find.isSync = true;
      box.put(find);
    }
  }

  void deleteByGuidFixedMany(List<String> guidFixedList) {
    Condition<ShiftObjectBoxStruct>? ids;
    for (var guidFixed in guidFixedList) {
      if (ids == null) {
        ids = ShiftObjectBoxStruct_.guidfixed.equals(guidFixed);
      } else {
        ids = ids.or(ShiftObjectBoxStruct_.guidfixed.equals(guidFixed));
      }
    }
    if (ids != null) {
      final find = box.query(ids).build().find();
      box.removeMany(find.map((data) => data.id).toList());
    }
  }

  List<ShiftObjectBoxStruct> getAll() {
    return (box.query()).build().find();
  }

  ShiftObjectBoxStruct getByGuid(String guid) {
    return box.query(ShiftObjectBoxStruct_.guidfixed.equals(guid)).build().findFirst()!;
  }

  List<ShiftObjectBoxStruct> select({String word = ""}) {
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
