import 'dart:async';
import 'dart:convert';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/objectbox/pos_log_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/objectbox.g.dart';

class PosLogHelper {
  final box = global.objectBoxStore.box<PosLogObjectBoxStruct>();

  Future<int> insert(PosLogObjectBoxStruct value) async {
    if (global.appMode == global.AppModeEnum.posClient) {
      HttpPost json = HttpPost(
          command: "PosLogHelper.insert", data: jsonEncode(value.toJson()));
      String result = await global.postToServerAndWait(
          ip: "${global.targetDeviceIpAddress}:${global.targetDeviceIpPort}",
          jsonData: jsonEncode(json.toJson()));
      return int.tryParse(result) ?? 0;
    } else {
      return box.put(value);
    }
  }

  Future<int> holdCount(int holdNumber) async {
    if (global.appMode == global.AppModeEnum.posClient) {
      HttpParameterModel jsonParameter =
          HttpParameterModel(holdNumber: holdNumber);
      HttpGetDataModel json = HttpGetDataModel(
          code: "PosLogHelper.holdCount",
          json: jsonEncode(jsonParameter.toJson()));
      String result =
          await global.getFromServer(json: jsonEncode(json.toJson()));
      return int.tryParse(result) ?? 0;
    } else {
      return box
          .query(PosLogObjectBoxStruct_.hold_number.equals(holdNumber))
          .build()
          .count();
    }
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

  int deleteByHoldNumber({required int holdNumber}) {
    final ids = box
        .query(PosLogObjectBoxStruct_.hold_number.equals(holdNumber))
        .build()
        .findIds();
    return box.removeMany(ids);
  }
}
