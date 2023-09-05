import 'package:dedepos/bloc/pay_screen_bloc.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/features/pos/presentation/screens/pay/pay_util.dart';
import 'package:dedepos/widgets/numpad.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';

class PayCredit extends StatefulWidget {
  final PosHoldProcessModel posProcess;
  final BuildContext blocContext;
  const PayCredit({super.key, required this.posProcess, required this.blocContext});

  @override
  State<PayCredit> createState() => _PayCreditState();
}

class _PayCreditState extends State<PayCredit> {
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void refreshEvent() {
    widget.blocContext.read<PayScreenBloc>().add(PayScreenRefresh());
  }

  Column buildDetailsBlock({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.green.shade500, fontSize: 18, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: (widget.posProcess.customerCode.isEmpty)
          ? Container(child: Center(child: Text(global.language("กรุณาเลือกรหัสลูกค้าก่อน"))))
          : Column(
              children: <Widget>[
                Container(padding: const EdgeInsets.all(10), width: double.infinity, child: buildDetailsBlock(label: "รหัสลูกค้า", value: widget.posProcess.customerCode)),
                Container(padding: const EdgeInsets.all(10), width: double.infinity, child: buildDetailsBlock(label: "ชื่อลูกค้า", value: widget.posProcess.customerName)),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                    height: 90,
                    child: ElevatedButton(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text(global.language('customer_code')),
                                  content: SizedBox(
                                    width: 300,
                                    height: 300,
                                    child: NumberPad(onChange: (value) {
                                      global.payScreenData.credit_amount = double.tryParse(value) ?? 0;
                                      refreshEvent();
                                    }),
                                  ));
                            },
                          );
                        },
                        child: Column(
                          children: [
                            Expanded(
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      global.moneyFormat.format(global.payScreenData.credit_amount),
                                      style: const TextStyle(fontSize: 32),
                                      textAlign: TextAlign.right,
                                    ))),
                            Text(
                              global.language('amount'),
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ))),
              ],
            ),
    )));
  }
}
