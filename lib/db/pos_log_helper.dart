import 'dart:async';
import 'dart:convert';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/objectbox/pos_log_struct.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/objectbox.g.dart';

class PosLogHelper {
  Future<int> insert(PosLogObjectBoxStruct value) async {
    if (global.appMode == global.AppModeEnum.posRemote) {
      HttpPost json = HttpPost(command: "PosLogHelper.insert", data: jsonEncode(value.toJson()));
      String result = await global.postToServerAndWait(ip: "${global.targetDeviceIpAddress}:${global.targetDeviceIpPort}", jsonData: jsonEncode(json.toJson()));
      return int.tryParse(result) ?? 0;
    } else {
      return global.objectBoxStore!.box<PosLogObjectBoxStruct>().put(value);
    }
  }

  Future<int> holdCount(String holdCode) async {
    if (global.appMode == global.AppModeEnum.posRemote) {
      HttpParameterModel jsonParameter = HttpParameterModel(holdCode: holdCode);
      HttpGetDataModel json = HttpGetDataModel(code: "PosLogHelper.holdCount", json: jsonEncode(jsonParameter.toJson()));
      String result = await global.getFromServer(json: jsonEncode(json.toJson()));
      return int.tryParse(result) ?? 0;
    } else {
      return global.objectBoxStore!.box<PosLogObjectBoxStruct>().query(PosLogObjectBoxStruct_.hold_code.equals(holdCode)).build().count();
    }
  }

  List<PosLogObjectBoxStruct> selectByHoldCodeIsVoidSuccess({required String holdCode, int isVoid = 0, int success = 0, required int docMode}) {
    return (global.objectBoxStore!.box<PosLogObjectBoxStruct>().query(PosLogObjectBoxStruct_.hold_code.equals(holdCode) &
            PosLogObjectBoxStruct_.is_void.equals(isVoid) &
            PosLogObjectBoxStruct_.doc_mode.equals(docMode) &
            PosLogObjectBoxStruct_.success.equals(success))
          ..order(PosLogObjectBoxStruct_.log_date_time))
        .build()
        .find();
  }

  Future<List<PosLogObjectBoxStruct>> selectByGuidFixed(String guidAutoFixed) async {
    if (global.appMode == global.AppModeEnum.posRemote) {
      HttpParameterModel jsonParameter = HttpParameterModel(guid: guidAutoFixed);
      HttpGetDataModel json = HttpGetDataModel(code: "PosLogHelper.selectByGuidFixed", json: jsonEncode(jsonParameter.toJson()));
      String result = await global.getFromServer(json: jsonEncode(json.toJson()));
      return (jsonDecode(result) as List).map((e) => PosLogObjectBoxStruct.fromJson(e)).toList();
    } else {
      return (global.objectBoxStore!.box<PosLogObjectBoxStruct>().query(PosLogObjectBoxStruct_.guid_auto_fixed.equals(guidAutoFixed))..order(PosLogObjectBoxStruct_.log_date_time))
          .build()
          .find();
    }
  }

  List<PosLogObjectBoxStruct> selectByGuidRefHoldCodeCommandCode({required String guidRef, required int commandCode, required String holdCode}) {
    return global.objectBoxStore!
        .box<PosLogObjectBoxStruct>()
        .query(PosLogObjectBoxStruct_.guid_ref.equals(guidRef) & PosLogObjectBoxStruct_.hold_code.equals(holdCode) & PosLogObjectBoxStruct_.command_code.equals(commandCode))
        .build()
        .find();
  }

  bool deleteByGuidRefHoldCodeCommandCode({required String guidRef, required int commandCode, required String holdCode}) {
    bool result = false;
    final find = global.objectBoxStore!
        .box<PosLogObjectBoxStruct>()
        .query(PosLogObjectBoxStruct_.guid_ref.equals(guidRef) & PosLogObjectBoxStruct_.hold_code.equals(holdCode) & PosLogObjectBoxStruct_.command_code.equals(commandCode))
        .build()
        .findFirst();
    if (find != null) {
      result = global.objectBoxStore!.box<PosLogObjectBoxStruct>().remove(find.id);
    }
    return result;
  }

  bool deleteByGuidCodeRefHoldCodeCommandCode({required String guidCode, required int commandCode, required String holdCode}) {
    bool result = false;
    final find = global.objectBoxStore!
        .box<PosLogObjectBoxStruct>()
        .query(PosLogObjectBoxStruct_.guid_code_ref.equals(guidCode) & PosLogObjectBoxStruct_.hold_code.equals(holdCode) & PosLogObjectBoxStruct_.command_code.equals(commandCode))
        .build()
        .findFirst();
    if (find != null) {
      result = global.objectBoxStore!.box<PosLogObjectBoxStruct>().remove(find.id);
    }
    return result;
  }

  Future<int> deleteByHoldCode({required String holdCode}) async {
    if (global.appMode == global.AppModeEnum.posRemote) {
      HttpPost json = HttpPost(command: "PosLogHelper.deleteByHoldCode", data: holdCode.toString());
      String result = await global.postToServerAndWait(ip: "${global.targetDeviceIpAddress}:${global.targetDeviceIpPort}", jsonData: jsonEncode(json.toJson()));
      return int.tryParse(result) ?? 0;
    } else {
      final ids = global.objectBoxStore!.box<PosLogObjectBoxStruct>().query(PosLogObjectBoxStruct_.hold_code.equals(holdCode)).build().findIds();
      return global.objectBoxStore!.box<PosLogObjectBoxStruct>().removeMany(ids);
    }
  }
}
