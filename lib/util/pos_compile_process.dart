import 'package:dedepos/core/core.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart';
import 'package:dedepos/pos_screen/pos_process.dart';

Future<PosProcessResultModel> posCompileProcess(
    {required int holdNumber, required int docMode}) async {
  PosProcessResultModel processResult = PosProcessResultModel();

  serviceLocator<Log>().debug("posCompileProcess()");
  {
    // คำนวณของ Terminal หลัก
    PosProcess posProcess = PosProcess();
    global.posHoldProcessResult[holdNumber].posProcess =
        await posProcess.process(holdNumber: holdNumber, docMode: docMode);
    posProcess.sumCategoryCount(
        value: global.posHoldProcessResult[holdNumber].posProcess);
    processResult = posProcess.result;
  }
  {
    // คำนวณของ Client
    for (int index = 0; index < global.posRemoteDeviceList.length; index++) {
      if (global.posRemoteDeviceList[index].processSuccess == false) {
        int getHoldNumber = global.posRemoteDeviceList[index].holdNumberActive;
        int getDocMode = global.posRemoteDeviceList[index].docModeActive;
        if (holdNumber != getHoldNumber) {
          PosProcess posProcess = PosProcess();
          global.posHoldProcessResult[getHoldNumber].posProcess =
              await posProcess.process(
                  holdNumber: getHoldNumber, docMode: getDocMode);
          posProcess.sumCategoryCount(
              value: global.posHoldProcessResult[getHoldNumber].posProcess);
        }
        global.posRemoteDeviceList[index].processSuccess = true;
      }
    }
  }
  global.sendProcessToCustomerDisplay();
  global.sendProcessToRemote();

  return processResult;
}
