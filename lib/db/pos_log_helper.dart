import 'dart:async';
import 'package:dedepos/model/objectbox/pos_log_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/objectbox.g.dart';

class PosLogHelper {
  final box = global.objectBoxStore.box<PosLogObjectBoxStruct>();

  int insert(PosLogObjectBoxStruct value) {
    return box.put(value);
  }

  int ticketCount(int ticketNumber) {
    return box
        .query(PosLogObjectBoxStruct_.ticket_number.equals(ticketNumber))
        .build()
        .find()
        .length;
  }

  List<PosLogObjectBoxStruct> selectByTicketNumberIsVoidSuccess(
      {required int ticketNumber, int isVoid = 0, int success = 0}) {
    return (box.query(
            PosLogObjectBoxStruct_.ticket_number.equals(ticketNumber) &
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

  List<PosLogObjectBoxStruct> selectByGuidRefTicketNumberCommandCode(
      {required String guidRef,
      required int commandCode,
      required int ticketNumber}) {
    return box
        .query(PosLogObjectBoxStruct_.guid_ref.equals(guidRef) &
            PosLogObjectBoxStruct_.ticket_number.equals(ticketNumber) &
            PosLogObjectBoxStruct_.command_code.equals(commandCode))
        .build()
        .find();
  }

  bool deleteByGuidRefTicketNumberCommandCode(
      {required String guidRef,
      required int commandCode,
      required int ticketNumber}) {
    bool result = false;
    final find = box
        .query(PosLogObjectBoxStruct_.guid_ref.equals(guidRef) &
            PosLogObjectBoxStruct_.ticket_number.equals(ticketNumber) &
            PosLogObjectBoxStruct_.command_code.equals(commandCode))
        .build()
        .findFirst();
    if (find != null) {
      result = box.remove(find.id);
    }
    return result;
  }

  bool deleteByGuidCodeRefTicketNumberCommandCode(
      {required String guidCode,
      required int commandCode,
      required int ticketNumber}) {
    bool result = false;
    final find = box
        .query(PosLogObjectBoxStruct_.guid_code_ref.equals(guidCode) &
            PosLogObjectBoxStruct_.ticket_number.equals(ticketNumber) &
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
