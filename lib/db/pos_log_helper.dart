import 'dart:async';
import 'package:dedepos/model/objectbox/pos_log_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/objectbox.g.dart';

class PosLogHelper {
  final _box = global.objectBoxStore.box<PosLogObjectBoxStruct>();

  int insert(PosLogObjectBoxStruct value) {
    return _box.put(value);
  }

  int holdCount(int holdNumber) {
    return _box
        .query(PosLogObjectBoxStruct_.hold_number.equals(holdNumber))
        .build()
        .find()
        .length;
  }

  List<PosLogObjectBoxStruct> selectByHoldNumberIsVoidSuccess(
      {int holdNumber = 0, int isVoid = 0, int success = 0}) {
    return (_box.query(PosLogObjectBoxStruct_.hold_number.equals(holdNumber) &
            PosLogObjectBoxStruct_.is_void.equals(isVoid) &
            PosLogObjectBoxStruct_.success.equals(success))
          ..order(PosLogObjectBoxStruct_.log_date_time))
        .build()
        .find();
  }

  List<PosLogObjectBoxStruct> selectByGuidFixed(String guidAutoFixed) {
    return (_box
            .query(PosLogObjectBoxStruct_.guid_auto_fixed.equals(guidAutoFixed))
          ..order(PosLogObjectBoxStruct_.log_date_time))
        .build()
        .find();
  }

  List<PosLogObjectBoxStruct> selectByGuidRefHoldNumberGroupCommandCode(
      {required String guidRef,
      required String group,
      required int commandCode,
      required int holdNumber}) {
    return _box
        .query(PosLogObjectBoxStruct_.guid_ref.equals(guidRef) &
            PosLogObjectBoxStruct_.hold_number.equals(holdNumber) &
            PosLogObjectBoxStruct_.guid_group.equals(group) &
            PosLogObjectBoxStruct_.command_code.equals(commandCode))
        .build()
        .find();
  }

  bool deleteByGuidRefHoldNumberGroupCommandCode(
      {required String guidRef,
      required String guidGroup,
      required int commandCode,
      required int holdNumber}) {
    bool _result = false;
    final _find = _box
        .query(PosLogObjectBoxStruct_.guid_ref.equals(guidRef) &
            PosLogObjectBoxStruct_.hold_number.equals(holdNumber) &
            PosLogObjectBoxStruct_.guid_group.equals(guidGroup) &
            PosLogObjectBoxStruct_.command_code.equals(commandCode))
        .build()
        .findFirst();
    if (_find != null) {
      _result = _box.remove(_find.id);
    }
    return _result;
  }

  bool deleteByGuidCodeRefHoldNumberGroupCommandCode(
      {required String guidCode,
      required String group,
      required int commandCode,
      required int holdNumber}) {
    bool _result = false;
    final _find = _box
        .query(PosLogObjectBoxStruct_.guid_code_ref.equals(guidCode) &
            PosLogObjectBoxStruct_.hold_number.equals(holdNumber) &
            PosLogObjectBoxStruct_.guid_group.equals(group) &
            PosLogObjectBoxStruct_.command_code.equals(commandCode))
        .build()
        .findFirst();
    if (_find != null) {
      _result = _box.remove(_find.id);
    }
    return _result;
  }

  bool delete({required String where}) {
    return false;
  }

  bool deleteById(int id) {
    return false;
  }

  void deleteAll() {
    this._box.removeAll();
  }

  bool update(PosLogObjectBoxStruct value) {
    return false;
  }

  void restart() {
    this._box.removeAll();
  }

  void success() {}
}
