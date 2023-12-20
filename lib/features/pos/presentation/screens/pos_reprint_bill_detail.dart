import 'package:dedepos/bloc/bill_bloc.dart';
import 'package:dedepos/db/bill_helper.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_print.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/global.dart' as global;

class PosReprintBillDetailScreen extends StatefulWidget {
  final global.PosScreenModeEnum posScreenMode;
  final String docNumber;

  @override
  const PosReprintBillDetailScreen({Key? key, required this.posScreenMode, required this.docNumber}) : super(key: key);

  @override
  State<PosReprintBillDetailScreen> createState() => _PosReprintBillDetailScreenState();
}

class _PosReprintBillDetailScreenState extends State<PosReprintBillDetailScreen> {
  late BillObjectBoxStruct bill;

  @override
  void initState() {
    super.initState();
    context.read<BillBloc>().add(BillLoadByDocNumber(docNumber: widget.docNumber, posScreenMode: widget.posScreenMode));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillBloc, BillState>(
      builder: (context, state) {
        if (state is BillLoadByDocNumberSuccess) {
          if (state.bill != null) {
            bill = state.bill!;
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
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          label: Text(global.language("reprint_bill")),
                          icon: const Icon(Icons.print),
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
                                            printBill(
                                                posScreenMode: widget.posScreenMode, docDate: bill.date_time, docNo: bill.doc_number, languageCode: global.userScreenLanguage);
                                            BillHelper().updateRePrintBill(bill.doc_number);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: Text(global.language("confirm"))),
                                    ],
                                  );
                                });
                          },
                        )),
                    const SizedBox(height: 10),
                    posBillDetail(docNumber: widget.docNumber),
                  ],
                ),
              )),
        );
      },
    );
  }
}
