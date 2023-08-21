import 'package:dedepos/bloc/pay_screen_bloc.dart';
import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/features/pos/presentation/screens/pay/pay_util.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/model/system/pos_pay_model.dart';
import 'package:dedepos/global_model.dart';

class PayCoupon extends StatefulWidget {
  final PosProcessModel posProcess;
  final BuildContext blocContext;
  const PayCoupon(
      {super.key, required this.posProcess, required this.blocContext});

  @override
  State<PayCoupon> createState() => _PayCouponState();
}

class _PayCouponState extends State<PayCoupon> {
  final _descriptionController = TextEditingController();
  final GlobalKey _couponNumberKey = GlobalKey();
  final GlobalKey _amountNumberKey = GlobalKey();
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
      global.payScreenData.coupon!.add(PayCouponModel(
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
                  child: SizedBox(
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
                              final RenderBox renderBox = _couponNumberKey
                                  .currentContext
                                  ?.findRenderObject() as RenderBox;
                              final Size size = renderBox.size;
                              final Offset offset =
                                  renderBox.localToGlobal(Offset.zero);
                              global.payScreenNumberPadLeft =
                                  offset.dx + (size.width * 1.1);
                              global.payScreenNumberPadTop =
                                  offset.dy - size.height;
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
                                        style: const TextStyle(fontSize: 32),
                                        textAlign: TextAlign.right,
                                      ))),
                              Text(
                                global.language('coupon_number'),
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )))),
              const SizedBox(width: 10),
              Expanded(
                  child: SizedBox(
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
                              final RenderBox renderBox = _amountNumberKey
                                  .currentContext
                                  ?.findRenderObject() as RenderBox;
                              final Size size = renderBox.size;
                              final Offset offset =
                                  renderBox.localToGlobal(Offset.zero);
                              global.payScreenNumberPadLeft =
                                  offset.dx + (size.width * 1.1);
                              global.payScreenNumberPadTop =
                                  offset.dy - size.height;
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
                                        style: const TextStyle(fontSize: 32),
                                        textAlign: TextAlign.right,
                                      ))),
                              Text(
                                global.language('money_amount'),
                                style: const TextStyle(fontSize: 16),
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
              border: const UnderlineInputBorder(),
              labelText: global.language('coupon_description'),
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
                  },
                  label: Text(
                    global.language("coupon_save"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 8,
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                      label: global.language("coupon_number"),
                      value: global.payScreenData.coupon[index].number),
                  const SizedBox(width: 10),
                  _buildDetailsBlock(
                      label: global.language("coupon_description"),
                      value: global.payScreenData.coupon[index].description),
                ],
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildDetailsBlock(
                        label: global.language('coupon_amount'),
                        value: global.moneyFormat.format(
                            global.payScreenData.coupon[index].amount)),
                  ],
                ),
              ),
              trailing: IconButton(
                  icon: const Icon(
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
                                .language("do_you_want_to_cancel_this_item")),
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
                                    global.payScreenData.coupon
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
          (global.payScreenData.coupon.isEmpty)
              ? Container()
              : Column(
                  children: <Widget>[
                    ...global.payScreenData.coupon.map((detail) {
                      var index = global.payScreenData.coupon.indexOf(detail);
                      return _buildCreditCard(index: index);
                    }).toList()
                  ],
                ),
        ],
      ),
    )));
  }
}
