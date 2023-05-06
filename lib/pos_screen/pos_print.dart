import 'package:dedepos/global.dart' as global;

Future<void> printBill(String docNo) async {
  if (global.posTicket.printMode == 0) {
    //printBillText(docNo);
  } else {
    //printBillImage(docNo);
  }
}
