import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/bank_and_wallet_struct.dart';
import 'package:dedepos/model/objectbox/member_struct.dart';
import 'package:dedepos/objectbox.g.dart';

class MasterBankHelper {
  final _box = global.objectBoxStore.box<BankAndWalletObjectBoxStruct>();

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

  /*int insert(BankStruct value) {
    return _box.put(value);
  }*/

  void insertMany(List<BankAndWalletObjectBoxStruct> values) {
    _box.putMany(values);
  }

  List<BankAndWalletObjectBoxStruct> select(
      {String where = "", int limit = 0, int offset = 0}) {
    if (where.isNotEmpty) where = " where " + where;
    return (_box.query()..order(BankAndWalletObjectBoxStruct_.wallettype))
        .build()
        .find();
  }

  Future<void> deleteAll() async {
    _box.removeAll();
  }
}
