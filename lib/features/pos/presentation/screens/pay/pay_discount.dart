import 'package:dedepos/bloc/pay_screen_bloc.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';

class PayDiscountWidget extends StatefulWidget {
  final PosHoldProcessModel posProcess;
  final BuildContext blocContext;

  const PayDiscountWidget({super.key, required this.posProcess, required this.blocContext});

  @override
  State<PayDiscountWidget> createState() => _PayDiscountWidgetState();
}

class _PayDiscountWidgetState extends State<PayDiscountWidget> {
  String textInputFormula = "";

  void refreshEvent() {
    global.payScreenData.discount_formula = textInputFormula;
    global.payScreenData.discount_amount = global.calcDiscountFormula(totalAmount: widget.posProcess.posProcess.total_amount, discountText: global.payScreenData.discount_formula);
    widget.blocContext.read<PayScreenBloc>().add(PayScreenRefresh());
  }

  void textInputAdd(String word) {
    textInputFormula = textInputFormula + word;
    refreshEvent();
  }

  Widget numberPad() {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  child: NumPadButton(
                margin: 2,
                text: '7',
                callBack: () => {textInputAdd("7")},
              )),
              Expanded(
                  child: NumPadButton(
                margin: 2,
                text: '8',
                callBack: () => {textInputAdd("8")},
              )),
              Expanded(
                  child: NumPadButton(
                margin: 2,
                text: '9',
                callBack: () => {textInputAdd("9")},
              )),
              Expanded(
                  child: NumPadButton(
                margin: 2,
                text: '%',
                callBack: () => {textInputAdd("%")},
              )),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  child: NumPadButton(
                margin: 2,
                text: '4',
                callBack: () => {textInputAdd("4")},
              )),
              Expanded(
                  child: NumPadButton(
                margin: 2,
                text: '5',
                callBack: () => {textInputAdd("5")},
              )),
              Expanded(
                  child: NumPadButton(
                margin: 2,
                text: '6',
                callBack: () => {textInputAdd("6")},
              )),
              Expanded(
                  child: NumPadButton(
                margin: 2,
                text: ',',
                callBack: () => {textInputAdd(",")},
              )),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  child: NumPadButton(
                margin: 2,
                text: '1',
                callBack: () => {textInputAdd("1")},
              )),
              Expanded(
                  child: NumPadButton(
                margin: 2,
                text: '2',
                callBack: () => {textInputAdd("2")},
              )),
              Expanded(
                  child: NumPadButton(
                margin: 2,
                text: '3',
                callBack: () => {textInputAdd("3")},
              )),
              Expanded(
                  child: NumPadButton(
                margin: 2,
                textAndIconColor: Colors.black,
                icon: Icons.backspace,
                color: Colors.red.shade200,
                callBack: () {
                  if (textInputFormula.isNotEmpty) {
                    textInputFormula = textInputFormula.substring(0, textInputFormula.length - 1);
                    refreshEvent();
                  }
                },
              )),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  child: NumPadButton(
                margin: 2,
                text: '0',
                callBack: () => {textInputAdd("0")},
              )),
              Expanded(
                  child: NumPadButton(
                margin: 2,
                text: '.',
                callBack: () => {if (!textInputFormula.contains('.')) textInputAdd((textInputFormula.isNotEmpty) ? "." : "0.")},
              )),
              Expanded(
                child: NumPadButton(
                  margin: 2,
                  text: 'C',
                  color: Colors.grey.shade400,
                  callBack: () {
                    textInputFormula = "";
                    refreshEvent();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8, top: 4),
                child: Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(offset: const Offset(0, 2), color: Colors.blueGrey.shade200, spreadRadius: 4, blurRadius: 4)]),
                  padding: const EdgeInsets.only(right: 15),
                  child: Stack(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(global.language('discount_formula_example'), // สูตรส่วนลด เช่น 5%,10,3%,20 = ลด 5% แล้วลดอีก 10 บาท แล้วลดอีก 3% แล้วลดอีก 20 บาท
                                  style: const TextStyle(color: Colors.grey, fontSize: 12)))),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(textInputFormula,
                            style: const TextStyle(color: Colors.blue, fontSize: 60, fontWeight: FontWeight.bold, shadows: [
                              Shadow(offset: Offset(-1, -1), color: Colors.white),
                              Shadow(offset: Offset(1, -1), color: Colors.white),
                              Shadow(offset: Offset(1, 1), color: Colors.white),
                              Shadow(offset: Offset(-1, 1), color: Colors.white),
                            ])),
                      ),
                    ],
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8, top: 4),
                child: Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(offset: const Offset(0, 2), color: Colors.blueGrey.shade200, spreadRadius: 4, blurRadius: 4)]),
                  padding: const EdgeInsets.only(right: 15),
                  child: Stack(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Align(alignment: Alignment.topLeft, child: Text(global.language('discount'), style: const TextStyle(color: Colors.grey, fontSize: 12)))),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(global.moneyFormat.format(global.payScreenData.discount_amount),
                            style: const TextStyle(color: Colors.blue, fontSize: 60, fontWeight: FontWeight.bold, shadows: [
                              Shadow(offset: Offset(-1, -1), color: Colors.white),
                              Shadow(offset: Offset(1, -1), color: Colors.white),
                              Shadow(offset: Offset(1, 1), color: Colors.white),
                              Shadow(offset: Offset(-1, 1), color: Colors.white),
                            ])),
                      ),
                    ],
                  ),
                )),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 4), child: numberPad())),
                ],
              ),
            ),
          ],
        ));
  }
}
