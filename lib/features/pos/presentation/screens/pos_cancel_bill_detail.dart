import 'package:dedepos/bloc/bill_bloc.dart';
import 'package:dedepos/db/bill_helper.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/global.dart' as global;

class PosCancelBillDetailScreen extends StatefulWidget {
  final global.PosScreenModeEnum posScreenMode;
  final String docNumber;

  @override
  const PosCancelBillDetailScreen({Key? key, required this.docNumber, required this.posScreenMode}) : super(key: key);

  @override
  State<PosCancelBillDetailScreen> createState() => _PosCancelBillDetailScreenState();
}

class _PosCancelBillDetailScreenState extends State<PosCancelBillDetailScreen> {
  late BillObjectBoxStruct bill = BillObjectBoxStruct(
      date_time: DateTime.now(),
      table_open_date_time: DateTime.now(),
      table_close_date_time: DateTime.now(),
      doc_number: "",
      doc_mode: 0,
      customer_code: "",
      bill_tax_type: 0,
      customer_name: "",
      customer_telephone: "",
      vat_rate: 0,
      total_amount: 0,
      total_vat_amount: 0,
      cashier_code: "",
      cashier_name: "",
      sale_code: "",
      amount_except_vat: 0,
      amount_before_calc_vat: 0,
      amount_after_calc_vat: 0,
      total_discount_vat_amount: 0,
      total_discount_except_vat_amount: 0,
      sale_name: "",
      vat_type: 0,
      total_qty: 0,
      is_sync: false,
      discount_formula: "",
      pay_cash_amount: 0,
      total_discount: 0,
      sum_qr_code: 0,
      sum_credit_card: 0,
      sum_money_transfer: 0,
      sum_coupon: 0,
      sum_cheque: 0,
      is_cancel: false,
      cancel_date_time: "",
      cancel_user_code: "",
      cancel_user_name: "",
      pay_cash_change: 0,
      cancel_reason: "",
      cancel_description: "",
      full_vat_print: false,
      full_vat_doc_number: "",
      full_vat_name: "",
      full_vat_address: "",
      full_vat_tax_id: "",
      full_vat_branch_number: "",
      table_number: "",
      child_count: 0,
      woman_count: 0,
      man_count: 0,
      table_al_la_crate_mode: false,
      buffet_code: "",
      pay_json: "",
      total_item_vat_amount: 0,
      total_item_except_vat_amount: 0,
      is_vat_register: false,
      detail_discount_formula: "",
      detail_total_amount: 0,
      detail_total_discount: 0,
      round_amount: 0,
      total_amount_after_discount: 0,
      sum_credit: 0,
      detail_total_amount_before_discount: 0,
      print_copy_bill_date_time: []);
  TextEditingController cancelDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BillBloc>().add(BillLoadByDocNumber(docNumber: widget.docNumber, posScreenMode: widget.posScreenMode));
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
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                columnWidths: const {
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(3),
                                },
                                children: [
                                  TableRow(children: [
                                    TableCell(
                                        child: Text(
                                      global.language("cancel_description"),
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
                                              title: Text(global.language("cancel_bill")),
                                              content: Text(bill.doc_number),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(global.language("cancel"))),
                                                TextButton(
                                                    onPressed: () {
                                                      bill.is_cancel = true;
                                                      BillHelper().updatesIsCancel(docNumber: bill.doc_number, description: cancelDescriptionController.text, value: true);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(global.language("confirm"))),
                                              ],
                                            );
                                          });
                                    },
                                  ))
                            ])),
                    posBillDetail(docNumber: widget.docNumber),
                  ],
                ),
              )),
        );
      },
    );
  }
}
