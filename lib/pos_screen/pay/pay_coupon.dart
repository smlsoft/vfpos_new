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

class PayCoupon extends StatefulWidget {
  final PosProcessModel posProcess;
  final BuildContext blocContext;
  const PayCoupon({required this.posProcess, required this.blocContext});

  @override
  _PayCouponState createState() => _PayCouponState();
}

class _PayCouponState extends State<PayCoupon> {
  final _descriptionController = TextEditingController();
  GlobalKey _couponNumberKey = GlobalKey();
  GlobalKey _amountNumberKey = GlobalKey();
  String _couponNumber = "";
  double _couponAmount = 0;
  int _buttonIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void refreshEvent() {
    widget.blocContext.read<PayScreenBloc>().add(PayScreenRefresh());
  }

  bool saveData() {
    if (_couponNumber.trim().isNotEmpty && _couponAmount > 0) {
      global.payScreenData.coupon.add(PayCouponModel(
          number: _couponNumber,
          description: _descriptionController.text,
          amount: _couponAmount));
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
              Expanded(
                  child: Container(
                      key: _couponNumberKey,
                      height: 90,
                      child: ElevatedButton(
                          onPressed: () {
                            global.numberPadCallBack = () {
                              setState(() {
                                _couponNumber = global.payScreenNumberPadText;
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
                              global.payScreenNumberPadText = _couponNumber;
                              final RenderBox _renderBox = _couponNumberKey
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
                          },
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        _couponNumber,
                                        style: TextStyle(fontSize: 32),
                                        textAlign: TextAlign.right,
                                      ))),
                              Text(
                                global.language('เลขที่คูปอง'),
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
                            global.numberPadCallBack = () {
                              setState(() {
                                _couponAmount = global.calcTextToNumber(
                                    global.payScreenNumberPadText);
                              });
                            };
                            if (global.payScreenNumberPadIsActive =
                                true && _buttonIndex == 2) {
                              global.payScreenNumberPadIsActive = false;
                              _buttonIndex = 0;
                            } else {
                              global.payScreenNumberPadIsActive = true;
                              global.payScreenNumberPadWidget =
                                  PayScreenNumberPadWidgetEnum.number;
                              global.payScreenNumberPadAmount = _couponAmount;
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
                              global.payScreenNumberPadAmount = _couponAmount;
                              global.payScreenNumberPadText =
                                  (_couponAmount == 0)
                                      ? ""
                                      : _couponAmount
                                          .toString()
                                          .replaceAll(".0", "");
                              _buttonIndex = 2;
                            }
                            refreshEvent();
                          },
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        global.moneyFormat
                                            .format(_couponAmount),
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
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: global.language('รายละเอียด'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.push_pin),
                  onPressed: () {
                    if (saveData()) {
                      _couponAmount = 0;
                      _couponNumber = "";
                      _descriptionController.text = "";
                      global.payScreenNumberPadText = "";
                      global.payScreenNumberPadAmount = 0;
                      refreshEvent();
                    }
                    ;
                  },
                  label: Text(
                    global.language("บันทึกคูปอง"),
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
                  _buildDetailsBlock(
                      label: global.language("เลขที่คูปอง"),
                      value: global.payScreenData.coupon[index].number),
                  SizedBox(width: 10),
                  _buildDetailsBlock(
                      label: global.language("รายละเอียด"),
                      value: global.payScreenData.coupon[index].description),
                ],
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildDetailsBlock(
                        label: global.language('ยอดเงิน'),
                        value: global.moneyFormat
                            .format(global.payScreenData.coupon[index].amount)),
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
                            content: Text("ต้องการยกเลิกรายการนี้จริงหรือไม่"),
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
                                    global.payScreenData.coupon.removeAt(index);
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
    if (_couponAmount == 0) _couponAmount = diffAmount();
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
                ...global.payScreenData.coupon.map((_detail) {
                  var _index = global.payScreenData.coupon.indexOf(_detail);
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
