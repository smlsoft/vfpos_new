import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/pos_screen/pos_process.dart';

Future<void> posCompileProcess() async {
  print("posCompileProcess()");
  // คำนวณของ Terminal หลัก
  global.posHoldProcessResult[global.posHoldActiveNumber].posProcess =
      await PosProcess().process(global.posHoldActiveNumber);
  PosProcess().sumCategoryCount(
      global.posHoldProcessResult[global.posHoldActiveNumber].posProcess);
  // คำนวณของ Client
  for (int index = 0; index < global.posClientDeviceList.length; index++) {
    if (global.posClientDeviceList[index].processSuccess == false) {
      int holdNumber = global.posClientDeviceList[index].holdNumberActive;
      if (global.posHoldActiveNumber != holdNumber) {
        global.posHoldProcessResult[holdNumber].posProcess =
            await PosProcess().process(holdNumber);
        PosProcess().sumCategoryCount(
            global.posHoldProcessResult[holdNumber].posProcess);
      }
      global.posClientDeviceList[index].processSuccess = true;
    }
  }
  global.sendProcessToCustomerDisplay();
  global.sendProcessToClient();
}
