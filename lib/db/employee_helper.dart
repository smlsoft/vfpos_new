import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/employees_struct.dart';
import 'package:dedepos/objectbox.g.dart';

class EmployeeHelper {
  final _box = global.objectBoxStore.box<EmployeeObjectBoxStruct>();
  /*static final EmployeeHelper _instance = EmployeeHelper.internal();

  factory EmployeeHelper() => _instance;

  EmployeeHelper.internal();

  Future<void> create() async {
    if (await global.findTable(global.employeeTableName) == false) {
      await global.clientDb!.execute("CREATE TABLE " +
          global.employeeTableName +
          " (guidfixed TEXT PRIMARY KEY,username TEXT, name TEXT,roles TEXT)");
    }
  }*/

  int insert(EmployeeObjectBoxStruct value) {
    return _box.put(value);
  }

  void insertMany(List<EmployeeObjectBoxStruct> values) {
    _box.putMany(values);
  }

  bool deleteByGuidFixed(String guidfixed) {
    bool _result = false;
    final _find = _box
        .query(EmployeeObjectBoxStruct_.guidfixed.equals(guidfixed))
        .build()
        .findFirst();
    if (_find != null) {
      _result = _box.remove(_find.id);
    }
    return _result;
  }

  void deleteByGuidFixedMany(List<String> guidfixed) {
    Condition<EmployeeObjectBoxStruct>? _ids;
    guidfixed.forEach((_guidfixed) {
      if (_ids == null)
        _ids = EmployeeObjectBoxStruct_.guidfixed.equals(_guidfixed);
      else
        _ids = _ids?.or(EmployeeObjectBoxStruct_.guidfixed.equals(_guidfixed));
    });
    if (_ids != null) {
      final _find = _box.query(_ids).build().find();
      _box.removeMany(_find.map((_data) => _data.id).toList());
    }
  }

  List<EmployeeObjectBoxStruct> getAll() {
    return (_box.query()).build().find();
  }

  List<EmployeeObjectBoxStruct> select({String word = ""}) {
    if (word.trim().isEmpty) {
      return (_box.query()).build().find();
    }
    return (_box.query()).build().find();
  }
}
