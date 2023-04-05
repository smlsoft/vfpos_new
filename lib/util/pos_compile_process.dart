import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/pos_screen/pos_process.dart';

Future<void> posCompileProcess({required int holdNumber}) async {
  print("posCompileProcess()");
  // คำนวณของ Terminal หลัก
  global.posHoldProcessResult[holdNumber].posProcess =
      await PosProcess().process(holdNumber);
  PosProcess()
      .sumCategoryCount(global.posHoldProcessResult[holdNumber].posProcess);
  // คำนวณของ Client
  for (int index = 0; index < global.posClientDeviceList.length; index++) {
    if (global.posClientDeviceList[index].processSuccess == false) {
      int getHoldNumber = global.posClientDeviceList[index].holdNumberActive;
      if (holdNumber != getHoldNumber) {
        global.posHoldProcessResult[getHoldNumber].posProcess =
            await PosProcess().process(getHoldNumber);
        PosProcess().sumCategoryCount(
            global.posHoldProcessResult[getHoldNumber].posProcess);
      }
      global.posClientDeviceList[index].processSuccess = true;
    }
  }
  global.sendProcessToCustomerDisplay();
  global.sendProcessToClient();
}
