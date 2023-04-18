import 'package:dedepos/bloc/bill_bloc.dart';
import 'package:dedepos/db/bill_helper.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/pos_screen/pos_print.dart';
import 'package:dedepos/pos_screen/pos_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/global.dart' as global;

class PosBillVatDetailScreen extends StatefulWidget {
  final String docNumber;

  @override
  const PosBillVatDetailScreen({Key? key, required this.docNumber})
      : super(key: key);

  _PosBillVatDetailScreenState createState() => _PosBillVatDetailScreenState();
}

class _PosBillVatDetailScreenState extends State<PosBillVatDetailScreen> {
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
            title: Text(global.language("pos_bill_vat_detail")),
          ),
          body: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                                child:
                                    Text(global.language("customer_tax_id"))),
                            TableCell(
                              child: TextField(
                                  controller: TextEditingController(
                                      text: bill.full_vat_tax_id)),
                            )
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text(global.language("customer_code"))),
                            TableCell(
                              child: TextField(
                                  controller: TextEditingController(
                                      text: bill.customer_code)),
                            )
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text(
                                    global.language("customer_branch_number"))),
                            TableCell(
                              child: TextField(
                                  controller: TextEditingController(
                                      text: bill.full_vat_branch_number)),
                            )
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text(global.language("customer_name"))),
                            TableCell(
                              child: TextField(
                                  controller: TextEditingController(
                                      text: bill.full_vat_name)),
                            )
                          ]),
                          TableRow(children: [
                            TableCell(
                                child:
                                    Text(global.language("customer_address"))),
                            TableCell(
                              child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  controller: TextEditingController(
                                      text: bill.full_vat_address)),
                            )
                          ]),
                        ]),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      child: Text(global.language("pos_bill_vat")),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(global.language("pos_bill_vat")),
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
                    const SizedBox(
                      height: 10,
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
