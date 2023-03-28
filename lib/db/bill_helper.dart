import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/objectbox.g.dart';

class BillHelper {
  final _box = global.objectBoxStore.box<BillObjectBoxStruct>();

  /*static final BillHelper _instance = BillHelper.internal();

  factory BillHelper() => _instance;

  BillHelper.internal();*/

/*  Future<void> create() async {
    if (await global.findTable(global.billTableName) == false) {
      await global.clientDb!.execute("CREATE TABLE " +
          global.billTableName +
          " (doc_number TEXT PRIMARY KEY,date_time datetime,time TEXT,customer_code TEXT,customer_name TEXT, customer_telephone TEXT,person_code TEXT,person_name TEXT,total_amount NUMERIC)");
    }
  }*/

  List<BillObjectBoxStruct> selectByDocNumber({String docNumber = ""}) {
    return _box
        .query(BillObjectBoxStruct_.doc_number.equals(docNumber))
        .build()
        .find();
  }

  List<BillObjectBoxStruct> selectSyncIsFalse() {
    return _box
        .query(BillObjectBoxStruct_.is_sync.equals(false))
        .build()
        .find();
  }

  int insert(BillObjectBoxStruct value) {
    return _box.put(value);
  }

  List<BillObjectBoxStruct> select(
      {String where = "", int limit = 0, int offset = 0}) {
    if (where.isNotEmpty) where = " where " + where;
    return (_box.query()).build().find();
  }

  bool deleteByDocNumber(String docNumber) {
    bool _result = false;
    final _find = _box
        .query(BillObjectBoxStruct_.doc_number.equals(docNumber))
        .build()
        .findFirst();
    if (_find != null) {
      _result = _box.remove(_find.id);
    }
    return _result;
  }
}
