import 'package:dedepos/core/core.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_process.dart';

Future<PosProcessResultModel> posCompileProcess(
    {required String holdCode, required int docMode}) async {
  PosProcessResultModel processResult = PosProcessResultModel();
  {
    // คำนวณของ Terminal หลัก
    PosProcess posProcess = PosProcess();
    int holdIndex = global.findPosHoldProcessResultIndex(holdCode);
    if (holdIndex != -1) {
      global
              .posHoldProcessResult[global.findPosHoldProcessResultIndex(holdCode)]
              .posProcess =
          await posProcess.process(
              holdCode: holdCode, docMode: docMode, discountFormula: "");
      posProcess.sumCategoryCount(
          value: global
              .posHoldProcessResult[
                  global.findPosHoldProcessResultIndex(holdCode)]
              .posProcess);
      processResult = posProcess.result;
    }
  }
  {
    // คำนวณของ Client
    for (int index = 0; index < global.posRemoteDeviceList.length; index++) {
      if (global.posRemoteDeviceList[index].processSuccess == false) {
        String getHoldCode = global.posRemoteDeviceList[index].holdCodeActive!;
        int getDocMode = global.posRemoteDeviceList[index].docModeActive!;
        if (holdCode != getHoldCode) {
          int holdIndex = global.findPosHoldProcessResultIndex(getHoldCode);
          if (holdIndex != -1) {
            PosProcess posProcess = PosProcess();
            global
                    .posHoldProcessResult[
                        global.findPosHoldProcessResultIndex(getHoldCode)]
                    .posProcess =
                await posProcess.process(
                    holdCode: getHoldCode,
                    docMode: getDocMode,
                    discountFormula: "");
            posProcess.sumCategoryCount(
                value: global
                    .posHoldProcessResult[
                        global.findPosHoldProcessResultIndex(getHoldCode)]
                    .posProcess);
          }
        }
        global.posRemoteDeviceList[index].processSuccess = true;
      }
    }
  }
  global.sendProcessToCustomerDisplay();
  global.sendProcessToRemote();

  return processResult;
}
