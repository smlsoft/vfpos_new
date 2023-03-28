import 'dart:convert';

import 'package:dedepos/bloc/pay_screen_bloc.dart';
import 'package:dedepos/model/json/pos_process_struct.dart';
import 'package:dedepos/pos_screen/pay/pay_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:dedepos/model/pos_pay_struct.dart';
import 'package:dedepos/global_model.dart';

class PayCreditCard extends StatefulWidget {
  final PosProcessStruct posProcess;
  final BuildContext blocContext;

  const PayCreditCard(
      {super.key, required this.posProcess, required this.blocContext});

  @override
  _PayCreditCardState createState() => _PayCreditCardState();
}

class _PayCreditCardState extends State<PayCreditCard> {
  GlobalKey cardNumberKey = GlobalKey();
  GlobalKey approveNumberKey = GlobalKey();
  GlobalKey amountNumberKey = GlobalKey();
  String bankCode = "";
  String bankName = "";
  String cardNumber = "";
  double cardAmount = 0;
  String approveNumber = "";
  int _buttonIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void refreshEvent() {
    widget.blocContext.read<PayScreenBloc>().add(PayScreenRefresh());
  }

  bool saveData() {
    if (cardNumber.trim().isNotEmpty && cardAmount > 0) {
      global.payScreenData.credit_card.add(PayCreditCardStruct(
          bank_code: bankCode,
          bank_name: bankName,
          card_number: cardNumber,
          approved_code: approveNumber,
          amount: cardAmount));
      return true;
    } else {
      return false;
    }
  }

  Widget cardDetail() {
    return Card(
      elevation: 3.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        padding: const EdgeInsets.all(5),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  height: 90,
                  child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                title: new Text(
                                    global.language("select_card_type")),
                                content: Container(
                                    width: 350,
                                    height: 300,
                                    child: new ListView.builder(
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                            padding: EdgeInsets.only(
                                                top: 4, bottom: 4),
                                            child: ElevatedButton(
                                              child: Row(children: [
                                                Container(
                                                    alignment: Alignment.center,
                                                    width: 100,
                                                    height: 50,
                                                    child: Image.asset(global
                                                        .findLogoImageFromCreditCardProvider(
                                                            global
                                                                .bankProviderList[
                                                                    index]
                                                                .paymentcode))),
                                                SizedBox(width: 10),
                                                Text(global
                                                    .bankProviderList[index]
                                                    .names[0]
                                                    .name)
                                              ]),
                                              onPressed: () {
                                                global.payScreenNumberPadIsActive =
                                                    false;
                                                bankCode = global
                                                    .bankProviderList[index]
                                                    .paymentcode;
                                                bankName = global
                                                    .bankProviderList[index]
                                                    .names[0]
                                                    .name;
                                                Navigator.of(context).pop();
                                                refreshEvent();
                                              },
                                            ));
                                      },
                                      itemCount: global.bankProviderList.length,
                                    ))));
                        refreshEvent();
                      },
                      child: Column(
                        children: [
                          Expanded(
                              child: Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  height: 50,
                                  child: (bankCode.isNotEmpty)
                                      ? Image.asset(global
                                          .findLogoImageFromCreditCardProvider(
                                              bankCode))
                                      : Container())),
                          Text(
                            global.language('bank'),
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ))),
              SizedBox(width: 10),
              Expanded(
                  child: Container(
                      key: cardNumberKey,
                      height: 90,
                      child: ElevatedButton(
                          onPressed: () {
                            if (bankCode.isNotEmpty) {
                              global.numberPadCallBack = () {
                                setState(() {
                                  cardNumber = global.payScreenNumberPadText;
                                });
                              };
                              if (global.payScreenNumberPadIsActive =
                                  true && _buttonIndex == 1) {
                                global.payScreenNumberPadIsActive = false;
                                _buttonIndex = 0;
                              } else {
                                global.payScreenNumberPadIsActive = true;
                                global.payScreenNumberPadWidget =
                                    payScreenNumberPadWidgetEnum.text;
                                global.payScreenNumberPadText = cardNumber;
                                final RenderBox _renderBox = cardNumberKey
                                    .currentContext
                                    ?.findRenderObject() as RenderBox;
                                final Size _size = _renderBox.size;
                                final Offset _offset =
                                    _renderBox.localToGlobal(Offset.zero);
                                global.payScreenNumberPadLeft =
                                    _offset.dx + (_size.width * 1.1);
                                global.payScreenNumberPadTop =
                                    _offset.dy - _size.height;
                                _buttonIndex = 1;
                              }
                              refreshEvent();
                            }
                          },
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        cardNumber,
                                        style: TextStyle(fontSize: 32),
                                        textAlign: TextAlign.right,
                                      ))),
                              Text(
                                global.language('card_number'),
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )))),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Container(
                      key: approveNumberKey,
                      height: 90,
                      child: ElevatedButton(
                          onPressed: () {
                            if (bankCode.isNotEmpty) {
                              global.numberPadCallBack = () {
                                setState(() {
                                  approveNumber = global.payScreenNumberPadText;
                                });
                              };
                              if (global.payScreenNumberPadIsActive =
                                  true && _buttonIndex == 2) {
                                global.payScreenNumberPadIsActive = false;
                                _buttonIndex = 0;
                              } else {
                                global.payScreenNumberPadIsActive = true;
                                global.payScreenNumberPadWidget =
                                    payScreenNumberPadWidgetEnum.text;
                                global.payScreenNumberPadText = approveNumber;
                                final RenderBox _renderBox = approveNumberKey
                                    .currentContext
                                    ?.findRenderObject() as RenderBox;
                                final Size _size = _renderBox.size;
                                final Offset _offset =
                                    _renderBox.localToGlobal(Offset.zero);
                                global.payScreenNumberPadLeft =
                                    _offset.dx + (_size.width * 1.5);
                                global.payScreenNumberPadTop =
                                    _offset.dy - _size.height;
                                _buttonIndex = 2;
                              }
                              refreshEvent();
                            }
                          },
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        approveNumber,
                                        style: TextStyle(fontSize: 32),
                                        textAlign: TextAlign.right,
                                      ))),
                              Text(
                                global.language('authorization_code'),
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )))),
              SizedBox(width: 10),
              Expanded(
                  child: Container(
                      key: amountNumberKey,
                      height: 90,
                      child: ElevatedButton(
                          onPressed: () {
                            if (bankCode.isNotEmpty) {
                              global.numberPadCallBack = () {
                                setState(() {
                                  cardAmount = global.calcTextToNumber(
                                      global.payScreenNumberPadText);
                                });
                              };
                              if (global.payScreenNumberPadIsActive =
                                  true && _buttonIndex == 3) {
                                global.payScreenNumberPadIsActive = false;
                                _buttonIndex = 0;
                              } else {
                                global.payScreenNumberPadIsActive = true;
                                global.payScreenNumberPadWidget =
                                    payScreenNumberPadWidgetEnum.number;
                                global.payScreenNumberPadAmount = cardAmount;
                                final RenderBox _renderBox = amountNumberKey
                                    .currentContext
                                    ?.findRenderObject() as RenderBox;
                                final Size _size = _renderBox.size;
                                final Offset _offset =
                                    _renderBox.localToGlobal(Offset.zero);
                                global.payScreenNumberPadLeft =
                                    _offset.dx + (_size.width * 1.1);
                                global.payScreenNumberPadTop =
                                    _offset.dy - _size.height;
                                global.payScreenNumberPadAmount = cardAmount;
                                global.payScreenNumberPadText =
                                    (cardAmount == 0)
                                        ? ""
                                        : cardAmount
                                            .toString()
                                            .replaceAll(".0", "");
                                _buttonIndex = 3;
                              }
                              refreshEvent();
                            }
                          },
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        global.moneyFormat.format(cardAmount),
                                        style: TextStyle(fontSize: 32),
                                        textAlign: TextAlign.right,
                                      ))),
                              Text(
                                global.language('amount'),
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.push_pin),
                  onPressed: () {
                    if (saveData()) {
                      bankCode = "";
                      cardAmount = 0;
                      cardNumber = "";
                      approveNumber = "";
                      global.payScreenNumberPadText = "";
                      global.payScreenNumberPadAmount = 0;
                      refreshEvent();
                    }
                    ;
                  },
                  label: Text(
                    global.language("credit_card_save"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 8,
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }

  Widget _buildCreditCard({required int index}) {
    return Column(
      children: [
        Card(
          elevation: 3.0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              title: Row(
                children: [
                  Container(
                      width: 100,
                      height: 50,
                      child: Image.asset(
                          global.findLogoImageFromCreditCardProvider(global
                              .payScreenData.credit_card[index].bank_code))),
                  SizedBox(width: 10),
                  Text(
                    global.language('card_number') + '  : ',
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'CourrierPrime'),
                  ),
                  Text(
                    global.payScreenData.credit_card[index].card_number,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'CourrierPrime'),
                  ),
                ],
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    buildDetailsBlock(
                      label: global.language('authorization_code'),
                      value:
                          global.payScreenData.credit_card[index].approved_code,
                    ),
                    buildDetailsBlock(
                        label: global.language('amount'),
                        value: global.moneyFormat.format(
                            global.payScreenData.credit_card[index].amount)),
                  ],
                ),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 30.0,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(global
                                .language("ต้องการยกเลิกรายการนี้จริงหรือไม่")),
                            actions: [
                              TextButton(
                                child: Text(global.language("cancel")),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(global.language("confirm")),
                                onPressed: () {
                                  setState(() {
                                    Navigator.of(context).pop();
                                    global.payScreenData.credit_card
                                        .removeAt(index);
                                    refreshEvent();
                                  });
                                },
                              ),
                            ],
                          );
                        });
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Column buildDetailsBlock({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(
              color: Colors.green.shade500,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cardAmount == 0) cardAmount = diffAmount();
    return Scaffold(
        backgroundColor: Colors.blue[100],
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            cardDetail(),
            Column(
              children: <Widget>[
                ...global.payScreenData.credit_card.map((_detail) {
                  var _index =
                      global.payScreenData.credit_card.indexOf(_detail);
                  return _buildCreditCard(index: _index);
                }).toList()
              ],
            ),
          ],
        )));
  }
}
