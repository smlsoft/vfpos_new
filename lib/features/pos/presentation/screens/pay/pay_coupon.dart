import 'package:dedepos/bloc/pay_screen_bloc.dart';
import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/features/pos/presentation/screens/pay/pay_util.dart';
import 'package:dedepos/widgets/numpad.dart';
import 'package:dedepos/widgets/numpadtext.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/model/system/pos_pay_model.dart';
import 'package:dedepos/global_model.dart';

class PayCoupon extends StatefulWidget {
  final PosHoldProcessModel posProcess;
  final BuildContext blocContext;
  const PayCoupon({super.key, required this.posProcess, required this.blocContext});

  @override
  State<PayCoupon> createState() => _PayCouponState();
}

class _PayCouponState extends State<PayCoupon> {
  final descriptionController = TextEditingController();
  final GlobalKey couponNumberKey = GlobalKey();
  final GlobalKey amountNumberKey = GlobalKey();
  String couponNumber = "";
  double couponAmount = 0;

  @override
  void initState() {
    super.initState();
  }

  void refreshEvent() {
    widget.blocContext.read<PayScreenBloc>().add(PayScreenRefresh());
  }

  bool saveData() {
    if (couponNumber.trim().isNotEmpty && couponAmount > 0) {
      global.payScreenData.coupon.add(PayCouponModel(number: couponNumber, description: descriptionController.text, amount: couponAmount));
      return true;
    } else {
      return false;
    }
  }

  Widget couponDetail() {
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
                      key: couponNumberKey,
                      height: 90,
                      child: ElevatedButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text(global.language('coupon_number')),
                                    content: SizedBox(
                                      width: 300,
                                      height: 300,
                                      child: NumberPadText(onChange: (value) {
                                        setState(() {
                                          couponNumber = value;
                                        });
                                      }),
                                    ));
                              },
                            );
                            refreshEvent();
                          },
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        couponNumber,
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
                      key: amountNumberKey,
                      height: 90,
                      child: ElevatedButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text(global.language('amount')),
                                    content: SizedBox(
                                      width: 300,
                                      height: 300,
                                      child: NumberPad(onChange: (value) {
                                        setState(() {
                                          couponAmount = double.tryParse(value) ?? 0;
                                        });
                                      }),
                                    ));
                              },
                            );
                            refreshEvent();
                          },
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        global.moneyFormat.format(couponAmount),
                                        style: const TextStyle(fontSize: 32),
                                        textAlign: TextAlign.right,
                                      ))),
                              Text(
                                global.language('amount'),
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )))),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descriptionController,
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
                      couponAmount = 0;
                      couponNumber = "";
                      descriptionController.text = "";
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

  Widget buildCouponCard({required int index}) {
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
                  buildDetailsBlock(label: global.language("coupon_number"), value: global.payScreenData.coupon[index].number),
                  const SizedBox(width: 10),
                  buildDetailsBlock(label: global.language("coupon_description"), value: global.payScreenData.coupon[index].description),
                ],
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    buildDetailsBlock(label: global.language('coupon_amount'), value: global.moneyFormat.format(global.payScreenData.coupon[index].amount)),
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
                            content: Text(global.language("do_you_want_to_cancel_this_item")),
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
    if (couponAmount == 0) couponAmount = diffAmount();
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          couponDetail(),
          (global.payScreenData.coupon.isEmpty)
              ? Container()
              : Column(
                  children: <Widget>[
                    ...global.payScreenData.coupon.map((detail) {
                      var index = global.payScreenData.coupon.indexOf(detail);
                      return buildCouponCard(index: index);
                    }).toList()
                  ],
                ),
        ],
      ),
    )));
  }
}
