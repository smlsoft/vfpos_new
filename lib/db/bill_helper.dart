import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/objectbox.g.dart';

class BillHelper {
  final box = global.objectBoxStore.box<BillObjectBoxStruct>();

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

  BillObjectBoxStruct? selectByDocNumber({String docNumber = ""}) {
    return box
        .query(BillObjectBoxStruct_.doc_number.equals(docNumber))
        .build()
        .findFirst();
  }

  List<BillObjectBoxStruct> selectSyncIsFalse() {
    return box.query(BillObjectBoxStruct_.is_sync.equals(false)).build().find();
  }

  int insert(BillObjectBoxStruct value) {
    return box.put(value);
  }

  List<BillObjectBoxStruct> select(
      {String where = "", int limit = 0, int offset = 0}) {
    return (box.query()).build().find();
  }

  List<BillObjectBoxStruct> selectOrderByDateTimeDesc() {
    return (box
            .query()
            .order(BillObjectBoxStruct_.date_time, flags: Order.descending)
            .build()
          ..limit = 100)
        .find();
  }

  bool deleteByDocNumber(String docNumber) {
    bool _result = false;
    final _find = box
        .query(BillObjectBoxStruct_.doc_number.equals(docNumber))
        .build()
        .findFirst();
    if (_find != null) {
      _result = box.remove(_find.id);
    }
    return _result;
  }

  void updatesIsCancel({required String docNumber, required bool value}) {
    final find = box
        .query(BillObjectBoxStruct_.doc_number.equals(docNumber))
        .build()
        .findFirst();
    if (find != null) {
      find.is_cancel = value;
      box.put(find);
    }
  }

  void updateRePrintBill(String docNumber) {
    final find = box
        .query(BillObjectBoxStruct_.doc_number.equals(docNumber))
        .build()
        .findFirst();
    if (find != null) {
      find.print_copy_bill_date_time.add(DateTime.now().toString());
      find.is_sync = false;
      box.put(find);
    }
  }
}
