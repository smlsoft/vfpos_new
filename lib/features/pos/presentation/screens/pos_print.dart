import 'package:dedepos/features/pos/presentation/screens/pos_print_text.dart';
import 'package:dedepos/global.dart' as global;

Future<void> printBill(String docNo) async {
  if (global.posTicket.printMode == 0) {
    printBillText(docNo);
  } else {
    //printBillImage(docNo);
  }
}
