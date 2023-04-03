import 'dart:convert';
import 'package:dedepos/bloc/pay_screen_bloc.dart';
import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/pos_screen/pay/pay_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:dedepos/model/system/pos_pay_model.dart';
import 'package:dedepos/global_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';

class PayCheque extends StatefulWidget {
  final PosProcessModel posProcess;
  final BuildContext blocContext;
  const PayCheque({required this.posProcess, required this.blocContext});

  @override
  _PayChequeState createState() => _PayChequeState();
}

class _PayChequeState extends State<PayCheque> {
  GlobalKey _chequeNumberKey = GlobalKey();
  GlobalKey _branchNumberKey = GlobalKey();
  GlobalKey _amountNumberKey = GlobalKey();
  GlobalKey _dueDateKey = GlobalKey();
  String _bankCode = "";
  String _bankName = "";
  String _chequeNumber = "";
  double _chequeAmount = 0;
  String _branchNumber = "";
  DateTime _dueDate = DateTime.now();
  int _buttonIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void refreshEvent() {
    widget.blocContext.read<PayScreenBloc>().add(PayScreenRefresh());
  }

  bool saveData() {
    if (_chequeNumber.trim().isNotEmpty && _chequeAmount > 0) {
      global.payScreenData.cheque.add(PayChequeModel(
          due_date: DateTime.now(),
          bank_code: _bankCode,
          bank_name: _bankName,
          cheque_number: _chequeNumber,
          branch_number: _branchNumber,
          amount: _chequeAmount));
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
                                    global.language("กรุณาเลือกธนาคาร")),
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
                                                _bankCode = global
                                                    .bankProviderList[index]
                                                    .paymentcode;
                                                _bankName = global
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
                                  child: (_bankCode.isNotEmpty)
                                      ? Image.asset(global
                                          .findLogoImageFromCreditCardProvider(
                                              _bankCode))
                                      : Container())),
                          Text(
                            'ธนาคาร',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ))),
              SizedBox(width: 10),
              Expanded(
                  child: Container(
                      key: _chequeNumberKey,
                      height: 90,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_bankCode.isNotEmpty) {
                              global.numberPadCallBack = () {
                                setState(() {
                                  _chequeNumber = global.payScreenNumberPadText;
                                });
                              };
                              if (global.payScreenNumberPadIsActive =
                                  true && _buttonIndex == 1) {
                                global.payScreenNumberPadIsActive = false;
                                _buttonIndex = 0;
                              } else {
                                global.payScreenNumberPadIsActive = true;
                                global.payScreenNumberPadWidget =
                                    PayScreenNumberPadWidgetEnum.text;
                                global.payScreenNumberPadText = _chequeNumber;
                                final RenderBox _renderBox = _chequeNumberKey
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
                                        _chequeNumber,
                                        style: TextStyle(fontSize: 32),
                                        textAlign: TextAlign.right,
                                      ))),
                              Text(
                                global.language('เลขที่เช็ค'),
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )))),
              SizedBox(width: 10),
              Expanded(
                  child: Container(
                      key: _branchNumberKey,
                      height: 90,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_bankCode.isNotEmpty) {
                              global.numberPadCallBack = () {
                                setState(() {
                                  _branchNumber = global.payScreenNumberPadText;
                                });
                              };
                              if (global.payScreenNumberPadIsActive =
                                  true && _buttonIndex == 2) {
                                global.payScreenNumberPadIsActive = false;
                                _buttonIndex = 0;
                              } else {
                                global.payScreenNumberPadIsActive = true;
                                global.payScreenNumberPadWidget =
                                    PayScreenNumberPadWidgetEnum.text;
                                global.payScreenNumberPadText = _branchNumber;
                                final RenderBox _renderBox = _branchNumberKey
                                    .currentContext
                                    ?.findRenderObject() as RenderBox;
                                final Size _size = _renderBox.size;
                                final Offset _offset =
                                    _renderBox.localToGlobal(Offset.zero);
                                global.payScreenNumberPadLeft =
                                    _offset.dx + (_size.width * 1.1);
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
                                        _branchNumber,
                                        style: TextStyle(fontSize: 32),
                                        textAlign: TextAlign.right,
                                      ))),
                              Text(
                                global.language('เลขที่สาขา'),
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
                      key: _dueDateKey,
                      height: 90,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_bankCode.isNotEmpty) {
                              global.payScreenNumberPadIsActive = false;
                              DateTime? _newDateTime =
                                  await showRoundedDatePicker(
                                context: context,
                                locale: Locale("th", "TH"),
                                era: EraMode.BUDDHIST_YEAR,
                                initialDate: _dueDate,
                                firstDate: DateTime(DateTime.now().year - 10),
                                lastDate: DateTime(DateTime.now().year + 10),
                                borderRadius: 16,
                              );
                              _dueDate = _newDateTime ?? DateTime.now();
                              refreshEvent();
                            }
                          },
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: FittedBox(
                                          child: Text(
                                        DateFormat.yMMMMEEEEd()
                                            .formatInBuddhistCalendarThai(
                                                _dueDate),
                                        style: TextStyle(fontSize: 32),
                                        textAlign: TextAlign.center,
                                      )))),
                              Text(
                                global.language('วันที่ถึงกำหนด'),
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )))),
              SizedBox(width: 10),
              Expanded(
                  child: Container(
                      key: _amountNumberKey,
                      height: 90,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_bankCode.isNotEmpty) {
                              global.numberPadCallBack = () {
                                setState(() {
                                  _chequeAmount = global.calcTextToNumber(
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
                                    PayScreenNumberPadWidgetEnum.number;
                                global.payScreenNumberPadAmount = _chequeAmount;
                                final RenderBox _renderBox = _amountNumberKey
                                    .currentContext
                                    ?.findRenderObject() as RenderBox;
                                final Size _size = _renderBox.size;
                                final Offset _offset =
                                    _renderBox.localToGlobal(Offset.zero);
                                global.payScreenNumberPadLeft =
                                    _offset.dx + (_size.width * 1.1);
                                global.payScreenNumberPadTop =
                                    _offset.dy - _size.height;
                                global.payScreenNumberPadAmount = _chequeAmount;
                                global.payScreenNumberPadText =
                                    (_chequeAmount == 0)
                                        ? ""
                                        : _chequeAmount
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
                                        global.moneyFormat
                                            .format(_chequeAmount),
                                        style: TextStyle(fontSize: 32),
                                        textAlign: TextAlign.right,
                                      ))),
                              Text(
                                global.language('จำนวนเงิน'),
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
                      _bankCode = "";
                      _chequeAmount = 0;
                      _chequeNumber = "";
                      _branchNumber = "";
                      global.payScreenNumberPadText = "";
                      global.payScreenNumberPadAmount = 0;
                      refreshEvent();
                    }
                    ;
                  },
                  label: Text(
                    global.language("บันทึกเช็ค"),
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
                          global.findLogoImageFromCreditCardProvider(
                              global.payScreenData.cheque[index].bank_code))),
                  SizedBox(width: 10),
                  _buildDetailsBlock(
                      label: global.language("เลขที่เช็ค"),
                      value: global.payScreenData.cheque[index].cheque_number),
                  SizedBox(width: 50),
                  _buildDetailsBlock(
                      label: global.language("เลขที่สาขา"),
                      value: global.payScreenData.cheque[index].branch_number),
                ],
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildDetailsBlock(
                      label: global.language('วันที่ถึงกำหนด'),
                      value: DateFormat.yMMMMEEEEd()
                          .formatInBuddhistCalendarThai(
                              global.payScreenData.cheque[index].due_date),
                    ),
                    _buildDetailsBlock(
                        label: global.language('ยอดเงิน'),
                        value: global.moneyFormat
                            .format(global.payScreenData.cheque[index].amount)),
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
                                    global.payScreenData.cheque.removeAt(index);
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

  Column _buildDetailsBlock({required String label, required String value}) {
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
    if (_chequeAmount == 0) _chequeAmount = diffAmount();
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          cardDetail(),
          Container(
            child: Column(
              children: <Widget>[
                ...global.payScreenData.cheque.map((_detail) {
                  var _index = global.payScreenData.cheque.indexOf(_detail);
                  return _buildCreditCard(index: _index);
                }).toList()
              ],
            ),
          ),
        ],
      ),
    )));
  }
}
