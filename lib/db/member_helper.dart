import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/member_struct.dart';
import 'package:dedepos/objectbox.g.dart';

class MemberHelper {
  final _box = global.objectBoxStore.box<MemberObjectBoxStruct>();

  /*static final MemberHelper _instance = MemberHelper.internal();

  factory MemberHelper() => _instance;

  MemberHelper.internal();

  Future<void> create() async {
    if (await global.findTable(global.memberTableName) == false) {
      await global.clientDb!.execute("CREATE TABLE " +
          global.memberTableName +
          " (guidfixed TEXT PRIMARY KEY, name TEXT,telephone TEXT, surname TEXT,taxid TEXT,contacttype int,personaltype int,branchtype int,branchcode TEXT,address TEXT,zipcode TEXT)");
    }
  }*/

  int insert(MemberObjectBoxStruct value) {
    return _box.put(value);
  }

  List<MemberObjectBoxStruct> select(
      {String where = "", int limit = 0, int offset = 0}) {
    if (where.isNotEmpty) where = " where $where";
    return (_box.query()).build().find();
  }

  bool deleteByGuidFixed(String guidfixed) {
    bool result = false;
    final find = _box
        .query(MemberObjectBoxStruct_.guidfixed.equals(guidfixed))
        .build()
        .findFirst();
    if (find != null) {
      result = _box.remove(find.id);
    }
    return result;
  }

  /*Future<int> deleteIn(String guidfixed) async {
    return await global.clientDb!.rawDelete("DELETE FROM " +
        global.memberTableName +
        " WHERE guidfixed in ('" +
        guidfixed +
        "')");
  }*/

  /*Future<bool> update(ProductStruct value) async {
    int _res = await global.clientDb!.update(global.memberTableName, value.toMap(), where: "barcode = ?", whereArgs: <String>[value.barcode]);
    return _res > 0 ? true : false;
  }*/
}
