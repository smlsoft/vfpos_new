import 'package:dedepos/bloc/pay_screen_bloc.dart';
import 'package:dedepos/model/json/pos_process_struct.dart';
import 'package:dedepos/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pay_widget.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:dedepos/model/pos_pay_struct.dart';

class PayDiscountWidget extends StatefulWidget {
  final PosProcessStruct posProcess;
  final BuildContext blocContext;

  const PayDiscountWidget(
      {required this.posProcess, required this.blocContext});

  _PayDiscountWidgetState createState() => _PayDiscountWidgetState();
}

class _PayDiscountWidgetState extends State<PayDiscountWidget> {
  String _textInputFormula = "";

  void refreshEvent() {
    global.payScreenData.discount_formula = _textInputFormula;
    global.payScreenData.discount_amount = global.calcDiscountFormula(
        totalAmount: widget.posProcess.total_amount,
        discountText: global.payScreenData.discount_formula);
    widget.blocContext.read<PayScreenBloc>().add(PayScreenRefresh());
  }

  void textInputAdd(String word) {
    _textInputFormula = _textInputFormula + word;
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
                  child: NumpadButton(
                text: '7',
                callBack: () => {textInputAdd("7")},
              )),
              Expanded(
                  child: NumpadButton(
                text: '8',
                callBack: () => {textInputAdd("8")},
              )),
              Expanded(
                  child: NumpadButton(
                text: '9',
                callBack: () => {textInputAdd("9")},
              )),
              Expanded(
                  child: NumpadButton(
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
                  child: NumpadButton(
                text: '4',
                callBack: () => {textInputAdd("4")},
              )),
              Expanded(
                  child: NumpadButton(
                text: '5',
                callBack: () => {textInputAdd("5")},
              )),
              Expanded(
                  child: NumpadButton(
                text: '6',
                callBack: () => {textInputAdd("6")},
              )),
              Expanded(
                  child: NumpadButton(
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
                  child: NumpadButton(
                text: '1',
                callBack: () => {textInputAdd("1")},
              )),
              Expanded(
                  child: NumpadButton(
                text: '2',
                callBack: () => {textInputAdd("2")},
              )),
              Expanded(
                  child: NumpadButton(
                text: '3',
                callBack: () => {textInputAdd("3")},
              )),
              Expanded(
                  child: NumpadButton(
                textAndIconColor: Colors.black,
                icon: Icons.backspace,
                color: Colors.red.shade200,
                callBack: () {
                  if (_textInputFormula.isNotEmpty) {
                    _textInputFormula = _textInputFormula.substring(
                        0, _textInputFormula.length - 1);
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
                  child: NumpadButton(
                text: '0',
                callBack: () => {textInputAdd("0")},
              )),
              Expanded(
                  child: NumpadButton(
                text: '.',
                callBack: () => {
                  if (_textInputFormula.indexOf('.') == -1)
                    textInputAdd((_textInputFormula.isNotEmpty) ? "." : "0.")
                },
              )),
              Expanded(
                child: NumpadButton(
                  text: 'C',
                  color: Colors.grey.shade400,
                  callBack: () {
                    _textInputFormula = "";
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
        padding: EdgeInsets.only(left: 4, right: 4, bottom: 8),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(left: 4, right: 4, bottom: 8, top: 4),
                child: Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  global.language(
                                      'สูตรส่วนลด เช่น 5%,10,3%,20 = ลด 5% แล้วลดอีก 10 บาท แล้วลดอีก 3% แล้วลดอีก 20 บาท'),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12)))),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(_textInputFormula,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                      offset: Offset(-1, -1),
                                      color: Colors.white),
                                  Shadow(
                                      offset: Offset(1, -1),
                                      color: Colors.white),
                                  Shadow(
                                      offset: Offset(1, 1),
                                      color: Colors.white),
                                  Shadow(
                                      offset: Offset(-1, 1),
                                      color: Colors.white),
                                ])),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 2),
                            color: Colors.blueGrey.shade200,
                            spreadRadius: 4,
                            blurRadius: 4)
                      ]),
                  padding: const EdgeInsets.only(right: 15),
                )),
            Padding(
                padding: EdgeInsets.only(left: 4, right: 4, bottom: 8, top: 4),
                child: Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(global.language('discount'),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12)))),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                            global.moneyFormat
                                .format(global.payScreenData.discount_amount),
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                      offset: Offset(-1, -1),
                                      color: Colors.white),
                                  Shadow(
                                      offset: Offset(1, -1),
                                      color: Colors.white),
                                  Shadow(
                                      offset: Offset(1, 1),
                                      color: Colors.white),
                                  Shadow(
                                      offset: Offset(-1, 1),
                                      color: Colors.white),
                                ])),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 2),
                            color: Colors.blueGrey.shade200,
                            spreadRadius: 4,
                            blurRadius: 4)
                      ]),
                  padding: const EdgeInsets.only(right: 15),
                )),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: numberPad())),
                ],
              ),
            ),
          ],
        ));
  }
}
