import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/buffet_mode_struct.dart';
import 'package:dedepos/model/objectbox/wallet_struct.dart';
import 'package:dedepos/objectbox.g.dart';

class WalletHelper {
  final box = global.objectBoxStore!.box<WalletObjectBoxStruct>();

  int insert(WalletObjectBoxStruct value) {
    return box.put(value);
  }

  void insertMany(List<WalletObjectBoxStruct> values) {
    box.putMany(values);
  }

  WalletObjectBoxStruct? getByCode(String code) {
    return box.query(WalletObjectBoxStruct_.code.equals(code)).build().findFirst();
  }

  bool deleteByCode(String code) {
    bool result = false;
    final find = box.query(WalletObjectBoxStruct_.code.equals(code)).build().findFirst();
    if (find != null) {
      result = box.remove(find.id);
    }
    return result;
  }

  List<WalletObjectBoxStruct> getAll() {
    return (box.query()).build().find();
  }

  List<WalletObjectBoxStruct> select({String word = ""}) {
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

  void deleteByGuidFixedMany(List<String> guidfixed) {
    Condition<WalletObjectBoxStruct>? ids;
    for (var guid in guidfixed) {
      if (ids == null) {
        ids = WalletObjectBoxStruct_.guid_fixed.equals(guid);
      } else {
        ids = ids.or(WalletObjectBoxStruct_.guid_fixed.equals(guid));
      }
    }
    if (ids != null) {
      final find = box.query(ids).build().find();
      box.removeMany(find.map((data) => data.id).toList());
    }
  }
}
