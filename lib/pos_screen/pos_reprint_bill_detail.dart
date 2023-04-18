import 'package:dedepos/bloc/bill_bloc.dart';
import 'package:dedepos/db/bill_helper.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/pos_screen/pos_print.dart';
import 'package:dedepos/pos_screen/pos_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/global.dart' as global;

class PosReprintBillDetailScreen extends StatefulWidget {
  final String docNumber;

  @override
  const PosReprintBillDetailScreen({Key? key, required this.docNumber})
      : super(key: key);

  _PosReprintBillDetailScreenState createState() =>
      _PosReprintBillDetailScreenState();
}

class _PosReprintBillDetailScreenState
    extends State<PosReprintBillDetailScreen> {
  BillObjectBoxStruct bill = BillObjectBoxStruct(date_time: DateTime.now());
  List<BillDetailObjectBoxStruct> billDetails = [];

  @override
  void initState() {
    super.initState();
    context
        .read<BillBloc>()
        .add(BillLoadByDocNumber(docNumber: widget.docNumber));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillBloc, BillState>(
      builder: (context, state) {
        if (state is BillLoadByDocNumberSuccess) {
          if (state.bill != null) {
            bill = state.bill!;
            billDetails = state.billDetails;
          }
          context.read<BillBloc>().add(BillLoadByDocNumberFinish());
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(global.language("reprint_bill_detail")),
          ),
          body: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ElevatedButton(
                      child: Text(global.language("reprint_bill")),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(global.language("reprint_bill")),
                                content: Text(bill.doc_number),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(global.language("cancel"))),
                                  TextButton(
                                      onPressed: () {
                                        printBill(bill.doc_number);
                                        BillHelper()
                                            .updateRePrintBill(bill.doc_number);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: Text(global.language("confirm"))),
                                ],
                              );
                            });
                      },
                    ),
                    posBillDetail(bill, billDetails),
                  ],
                ),
              )),
        );
      },
    );
  }
}
