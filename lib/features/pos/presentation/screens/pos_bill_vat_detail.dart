import 'dart:convert';

import 'package:dedepos/bloc/bill_bloc.dart';
import 'package:dedepos/db/bill_helper.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_print.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/global.dart' as global;

class PosBillVatDetailScreen extends StatefulWidget {
  final String docNumber;

  @override
  const PosBillVatDetailScreen({Key? key, required this.docNumber})
      : super(key: key);

  @override
  State<PosBillVatDetailScreen> createState() => _PosBillVatDetailScreenState();
}

class _PosBillVatDetailScreenState extends State<PosBillVatDetailScreen> {
  late BillObjectBoxStruct bill;
  TextEditingController taxIdController = TextEditingController();
  TextEditingController customerCodeController = TextEditingController();
  TextEditingController branchNumberController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context
        .read<BillBloc>()
        .add(BillLoadByDocNumber(docNumber: widget.docNumber));
  }

  @override
  void dispose() {
    taxIdController.dispose();
    customerCodeController.dispose();
    branchNumberController.dispose();
    customerNameController.dispose();
    customerAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillBloc, BillState>(
      builder: (context, state) {
        if (state is BillLoadByDocNumberSuccess) {
          if (state.bill != null) {
            bill = state.bill!;
            taxIdController.text = bill.full_vat_tax_id;
            customerCodeController.text = bill.customer_code;
            branchNumberController.text = bill.full_vat_branch_number;
            customerNameController.text = bill.full_vat_name;
            customerAddressController.text = bill.full_vat_address;
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
                                child: Text(
                              global.language("customer_tax_id"),
                            )),
                            TableCell(
                              child: TextField(
                                controller: taxIdController,
                              ),
                            )
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text(
                                    global.language("customer_branch_number"))),
                            TableCell(
                              child: TextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: branchNumberController),
                            )
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text(global.language("customer_code"))),
                            TableCell(
                              child:
                                  TextField(controller: customerCodeController),
                            )
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Text(global.language("customer_name"))),
                            TableCell(
                              child:
                                  TextField(controller: customerNameController),
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
                                  controller: customerAddressController),
                            )
                          ]),
                        ]),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          label: Text(global.language("pos_bill_vat")),
                          icon: const Icon(Icons.print),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title:
                                        Text(global.language("pos_bill_vat")),
                                    content: Text(bill.doc_number),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child:
                                              Text(global.language("cancel"))),
                                      TextButton(
                                          onPressed: () {
                                            BillHelper().updatesFullVat(
                                              docNumber: bill.doc_number,
                                              taxId: taxIdController.text,
                                              branchNumber:
                                                  branchNumberController.text,
                                              customerCode:
                                                  customerCodeController.text,
                                              customerName:
                                                  customerNameController.text,
                                              customerAddress:
                                                  customerAddressController
                                                      .text,
                                            );
                                            printBill(
                                                docDate: bill.date_time,
                                                docNo: bill.doc_number,
                                                languageCode:
                                                    global.userScreenLanguage);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child:
                                              Text(global.language("confirm"))),
                                    ],
                                  );
                                });
                          },
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    posBillDetail(docNumber: widget.docNumber),
                  ],
                ),
              )),
        );
      },
    );
  }
}
