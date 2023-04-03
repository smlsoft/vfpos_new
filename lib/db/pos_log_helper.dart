import 'dart:async';
import 'package:dedepos/model/objectbox/pos_log_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/objectbox.g.dart';

class PosLogHelper {
  final box = global.objectBoxStore.box<PosLogObjectBoxStruct>();

  int insert(PosLogObjectBoxStruct value) {
    return box.put(value);
  }

  int holdCount(int holdNumber) {
    return box
        .query(PosLogObjectBoxStruct_.hold_number.equals(holdNumber))
        .build()
        .find()
        .length;
  }

  List<PosLogObjectBoxStruct> selectByHoldNumberIsVoidSuccess(
      {required int holdNumber, int isVoid = 0, int success = 0}) {
    return (box.query(PosLogObjectBoxStruct_.hold_number.equals(holdNumber) &
            PosLogObjectBoxStruct_.is_void.equals(isVoid) &
            PosLogObjectBoxStruct_.success.equals(success))
          ..order(PosLogObjectBoxStruct_.log_date_time))
        .build()
        .find();
  }

  List<PosLogObjectBoxStruct> selectByGuidFixed(String guidAutoFixed) {
    return (box
            .query(PosLogObjectBoxStruct_.guid_auto_fixed.equals(guidAutoFixed))
          ..order(PosLogObjectBoxStruct_.log_date_time))
        .build()
        .find();
  }

  List<PosLogObjectBoxStruct> selectByGuidRefHoldNumberCommandCode(
      {required String guidRef,
      required int commandCode,
      required int holdNumber}) {
    return box
        .query(PosLogObjectBoxStruct_.guid_ref.equals(guidRef) &
            PosLogObjectBoxStruct_.hold_number.equals(holdNumber) &
            PosLogObjectBoxStruct_.command_code.equals(commandCode))
        .build()
        .find();
  }

  bool deleteByGuidRefHoldNumberCommandCode(
      {required String guidRef,
      required int commandCode,
      required int holdNumber}) {
    bool result = false;
    final find = box
        .query(PosLogObjectBoxStruct_.guid_ref.equals(guidRef) &
            PosLogObjectBoxStruct_.hold_number.equals(holdNumber) &
            PosLogObjectBoxStruct_.command_code.equals(commandCode))
        .build()
        .findFirst();
    if (find != null) {
      result = box.remove(find.id);
    }
    return result;
  }

  bool deleteByGuidCodeRefHoldNumberCommandCode(
      {required String guidCode,
      required int commandCode,
      required int holdNumber}) {
    bool result = false;
    final find = box
        .query(PosLogObjectBoxStruct_.guid_code_ref.equals(guidCode) &
            PosLogObjectBoxStruct_.hold_number.equals(holdNumber) &
            PosLogObjectBoxStruct_.command_code.equals(commandCode))
        .build()
        .findFirst();
    if (find != null) {
      result = box.remove(find.id);
    }
    return result;
  }

  bool delete({required String where}) {
    return false;
  }

  bool deleteById(int id) {
    return false;
  }

  void deleteAll() {
    box.removeAll();
  }

  bool update(PosLogObjectBoxStruct value) {
    return false;
  }

  void restart() {
    box.removeAll();
  }

  void success() {}
}
