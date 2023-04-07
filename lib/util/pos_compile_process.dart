import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/pos_screen/pos_process.dart';

Future<PosProcessResultModel> posCompileProcess(
    {required int holdNumber}) async {
  PosProcessResultModel processResult = PosProcessResultModel();

  print("posCompileProcess()");
  {
    // คำนวณของ Terminal หลัก
    PosProcess posProcess = PosProcess();
    global.posHoldProcessResult[holdNumber].posProcess =
        await posProcess.process(holdNumber);
    posProcess
        .sumCategoryCount(global.posHoldProcessResult[holdNumber].posProcess);
    processResult = posProcess.result;
  }
  {
    // คำนวณของ Client
    for (int index = 0; index < global.posRemoteDeviceList.length; index++) {
      if (global.posRemoteDeviceList[index].processSuccess == false) {
        int getHoldNumber = global.posRemoteDeviceList[index].holdNumberActive;
        if (holdNumber != getHoldNumber) {
          PosProcess posProcess = PosProcess();
          global.posHoldProcessResult[getHoldNumber].posProcess =
              await posProcess.process(getHoldNumber);
          posProcess.sumCategoryCount(
              global.posHoldProcessResult[getHoldNumber].posProcess);
        }
        global.posRemoteDeviceList[index].processSuccess = true;
      }
    }
  }
  global.sendProcessToCustomerDisplay();
  global.sendProcessToRemote();

  return processResult;
}
