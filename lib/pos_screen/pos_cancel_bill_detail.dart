import 'package:dedepos/bloc/bill_bloc.dart';
import 'package:dedepos/db/bill_helper.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/pos_screen/pos_print.dart';
import 'package:dedepos/pos_screen/pos_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/global.dart' as global;

class PosCancelBillDetailScreen extends StatefulWidget {
  final String docNumber;

  @override
  const PosCancelBillDetailScreen({Key? key, required this.docNumber})
      : super(key: key);

  _PosCancelBillDetailScreenState createState() =>
      _PosCancelBillDetailScreenState();
}

class _PosCancelBillDetailScreenState extends State<PosCancelBillDetailScreen> {
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
            title: Text(global.language("cancel_bill_detail")),
          ),
          body: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    (bill.is_cancel)
                        ? Container()
                        : ElevatedButton(
                            child: Text(global.language("cancel_bill")),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:
                                          Text(global.language("cancel_bill")),
                                      content: Text(bill.doc_number),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                                global.language("cancel"))),
                                        TextButton(
                                            onPressed: () {
                                              bill.is_cancel = true;
                                              BillHelper().updatesIsCancel(
                                                  docNumber: bill.doc_number,
                                                  value: true);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                                global.language("confirm"))),
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
