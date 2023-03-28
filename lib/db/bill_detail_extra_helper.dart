import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/objectbox.g.dart';

class BillDetailExtraHelper {
  final _box = global.objectBoxStore.box<BillDetailExtraObjectBoxStruct>();

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

  List<BillDetailExtraObjectBoxStruct> selectByDocNumberAndLineNumber(
      {String docNumber = "", int lineNumber = 0}) {
    return _box
        .query(BillDetailExtraObjectBoxStruct_.doc_number.equals(docNumber).and(
            BillDetailExtraObjectBoxStruct_.ref_line_number.equals(lineNumber)))
        .build()
        .find();
  }

  int insert(BillDetailExtraObjectBoxStruct value) {
    return _box.put(value);
  }

  void insertMany(List<BillDetailExtraObjectBoxStruct> value) {
    _box.putMany(value);
  }

  List<BillDetailExtraObjectBoxStruct> select(
      {String where = "", int limit = 0, int offset = 0}) {
    if (where.isNotEmpty) where = " where " + where;
    return (_box.query()).build().find();
  }
}
