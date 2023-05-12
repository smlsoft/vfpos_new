import 'package:dedepos/bloc/bill_bloc.dart';
import 'package:dedepos/db/bill_helper.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/pos_screen/pos_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/global.dart' as global;

class PosCancelBillDetailScreen extends StatefulWidget {
  final String docNumber;

  @override
  const PosCancelBillDetailScreen({Key? key, required this.docNumber})
      : super(key: key);

  @override
  State<PosCancelBillDetailScreen> createState() =>
      _PosCancelBillDetailScreenState();
}

class _PosCancelBillDetailScreenState extends State<PosCancelBillDetailScreen> {
  BillObjectBoxStruct bill = BillObjectBoxStruct(date_time: DateTime.now());
  List<BillDetailObjectBoxStruct> billDetails = [];
  TextEditingController cancelDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context
        .read<BillBloc>()
        .add(BillLoadByDocNumber(docNumber: widget.docNumber));
  }

  @override
  void dispose() {
    cancelDescriptionController.dispose();
    super.dispose();
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
            title: Text(global.language("cancel_bill_detail")),
          ),
          body: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    (bill.is_cancel)
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            width: double.infinity,
                            child: Column(children: [
                              Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                columnWidths: const {
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(3),
                                },
                                children: [
                                  TableRow(children: [
                                    TableCell(
                                        child: Text(
                                      global.language("calcel_description"),
                                    )),
                                    TableCell(
                                      child: TextField(
                                        controller: cancelDescriptionController,
                                      ),
                                    )
                                  ]),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    child: Text(global.language("cancel_bill")),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(global
                                                  .language("cancel_bill")),
                                              content: Text(bill.doc_number),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(global
                                                        .language("cancel"))),
                                                TextButton(
                                                    onPressed: () {
                                                      bill.is_cancel = true;
                                                      BillHelper()
                                                          .updatesIsCancel(
                                                              docNumber: bill
                                                                  .doc_number,description : cancelDescriptionController.text,
                                                              value: true);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(global
                                                        .language("confirm"))),
                                              ],
                                            );
                                          });
                                    },
                                  ))
                            ])),
                    posBillDetail(bill, billDetails),
                  ],
                ),
              )),
        );
      },
    );
  }
}
