import 'package:dedepos/bloc/pay_screen_bloc.dart';
import 'package:dedepos/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pay_widget.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:dedepos/model/pos_pay_struct.dart';

class PayCashWidget extends StatefulWidget {
  final BuildContext blocContext;

  PayCashWidget({required this.blocContext});
  _PayCashWidgetState createState() => _PayCashWidgetState();
}

class _PayCashWidgetState extends State<PayCashWidget> {
  @override
  void initState() {
    super.initState();
  }

  void refreshEvent() {
    widget.blocContext.read<PayScreenBloc>().add(PayScreenRefresh());
  }

  void textInputAdd(String word) {
    global.payScreenData.cash_amount_text =
        global.payScreenData.cash_amount_text + word;
    global.payScreenData.cash_amount =
        global.calcTextToNumber(global.payScreenData.cash_amount_text);
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
                  if (!global.payScreenData.cash_amount_text.contains('.'))
                    textInputAdd(
                        (global.payScreenData.cash_amount_text.isNotEmpty)
                            ? "."
                            : "0.")
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
                textAndIconColor: Colors.black,
                icon: Icons.backspace,
                color: Colors.red.shade200,
                callBack: () {
                  if (global.payScreenData.cash_amount_text.isNotEmpty) {
                    global.payScreenData.cash_amount_text =
                        global.payScreenData.cash_amount_text.substring(0,
                            global.payScreenData.cash_amount_text.length - 1);
                    global.payScreenData.cash_amount = global.calcTextToNumber(
                        global.payScreenData.cash_amount_text);
                    refreshEvent();
                  }
                },
              )),
              Expanded(
                child: NumpadButton(
                  text: 'C',
                  color: Colors.grey.shade400,
                  callBack: () {
                    global.payScreenData.cash_amount_text = "";
                    global.payScreenData.cash_amount = 0;
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

  Widget moneyButton(double value) {
    return Material(
      elevation: 4.0,
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.passthrough,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("+${value.toStringAsFixed(0)}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [
                        Shadow(offset: Offset(-1, -1), color: Colors.white),
                        Shadow(offset: Offset(1, -1), color: Colors.white),
                        Shadow(offset: Offset(1, 1), color: Colors.white),
                        Shadow(offset: Offset(-1, 1), color: Colors.white),
                      ])),
            ),
          ),
          Padding(
              padding:
                  const EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 4),
              child: Ink.image(
                image: AssetImage(
                    'assets/images/moneythai${value.toStringAsFixed(0)}.gif'),
                fit: BoxFit.fill,
                child: InkWell(onTap: () {
                  global.payScreenData.cash_amount =
                      global.payScreenData.cash_amount + value;
                  global.payScreenData.cash_amount_text =
                      global.payScreenData.cash_amount.toString();
                  refreshEvent();
                }),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: Column(children: [
          Padding(
              padding:
                  const EdgeInsets.only(left: 4, right: 4, bottom: 8, top: 4),
              child: Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 2),
                          color: Colors.blueGrey.shade200,
                          spreadRadius: 4,
                          blurRadius: 4)
                    ]),
                padding: const EdgeInsets.only(right: 15),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                      global.moneyFormat
                          .format(global.payScreenData.cash_amount),
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(offset: Offset(-1, -1), color: Colors.white),
                            Shadow(offset: Offset(1, -1), color: Colors.white),
                            Shadow(offset: Offset(1, 1), color: Colors.white),
                            Shadow(offset: Offset(-1, 1), color: Colors.white),
                          ])),
                ),
              )),
          Expanded(
            child: Column(
              children: [
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: numberPad())),
                Container(
                  height: 80,
                  margin: const EdgeInsets.only(left: 4, right: 4),
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 2),
                            color: Colors.blueGrey.shade200,
                            spreadRadius: 2,
                            blurRadius: 2)
                      ]),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(child: moneyButton(1000)),
                      Expanded(child: moneyButton(500)),
                      Expanded(child: moneyButton(100)),
                      Expanded(child: moneyButton(50)),
                      Expanded(child: moneyButton(20)),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]));
  }
}