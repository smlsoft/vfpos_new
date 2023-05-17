import 'package:dedepos/global_model.dart';
import 'package:dedepos/bloc/pay_screen_bloc.dart';
import 'package:dedepos/model/system/bank_and_wallet_model.dart';
import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/features/pos/presentation/screens/pay/pay_qr_screen.dart';
import 'package:dedepos/features/pos/presentation/screens/pay/pay_util.dart';
import 'package:dedepos/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/model/system/pos_pay_model.dart';

class PayQrWidget extends StatefulWidget {
  final PosProcessModel posProcess;
  final BuildContext blocContext;

  const PayQrWidget(
      {super.key, required this.posProcess, required this.blocContext});

  @override
  PayQrWidgetState createState() => PayQrWidgetState();
}

class PayQrWidgetState extends State<PayQrWidget> {
  final _descriptionController = TextEditingController();
  double _amount = 0;
  GlobalKey widgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void refreshEvent() {
    widget.blocContext.read<PayScreenBloc>().add(PayScreenRefresh());
  }

  bool saveData(String providerCode, String providerName) {
    global.payScreenNumberPadIsActive = false;
    if (_amount > 0) {
      global.payScreenData.qr.add(PayQrModel(
          provider_code: providerCode,
          provider_name: providerName,
          description: _descriptionController.text,
          amount: _amount));
      return true;
    }
    return false;
  }

  Widget formDetail() {
    return Container(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(global
              .language('กรณีชำระด้วย QR Code มากกว่า 1 รายการ (แบ่งจ่าย)')),
          Container(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: Row(children: [
              Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: global.language('รายละเอียด'),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: SizedBox(
                      key: widgetKey,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            global.numberPadCallBack = () {
                              setState(() {
                                _amount = global.calcTextToNumber(
                                    global.payScreenNumberPadText);
                              });
                            };
                            global.payScreenNumberPadIsActive =
                                !global.payScreenNumberPadIsActive;
                            FocusScope.of(context).unfocus();
                            global.payScreenNumberPadWidget =
                                PayScreenNumberPadWidgetEnum.number;
                            final RenderBox renderBox = widgetKey.currentContext
                                ?.findRenderObject() as RenderBox;
                            final Size size = renderBox.size;
                            final Offset offset =
                                renderBox.localToGlobal(Offset.zero);
                            global.payScreenNumberPadLeft =
                                offset.dx + (size.width * 1.1);
                            global.payScreenNumberPadTop =
                                offset.dy - size.height;
                            global.payScreenNumberPadAmount = _amount;
                            global.payScreenNumberPadText = (_amount == 0)
                                ? ""
                                : _amount.toString().replaceAll(".0", "");
                            refreshEvent();
                          },
                          child: Column(
                            children: [
                              Text(
                                global.language('จำนวนเงิน'),
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.right,
                              ),
                              Text(global.moneyFormat.format(_amount),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right),
                            ],
                          )))),
            ]),
          ),
          const SizedBox(height: 8),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green.shade400, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(2),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4)),
                        color: Colors.green,
                      ),
                      child: Center(
                        child: Text(
                            '${global.language('ประเภท Wallet ชำระจำนวน')} : ${global.moneyFormat.format(_amount)} ${global.language('money_symbol')}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      )),
                  qrList(_amount),
                ],
              )),
        ]),
      ),
    );
  }

  Container buildCard({required int index}) {
    return Container(
      padding: const EdgeInsets.all(4),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
          title: Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    Image.asset(
                      ("assets/images/qrpay/${global.payScreenData.qr[index].provider_code}.png")
                          .toLowerCase(),
                      height: 40,
                    ),
                    Text(global.payScreenData.qr[index].provider_name)
                  ],
                ),
                buildDetailsBlock(
                  label: global.language('รายละเอียด'),
                  value: global.payScreenData.qr[index].description,
                ),
                buildDetailsBlock(
                    label: global.language('ยอดเงิน'),
                    value: global.moneyFormat
                        .format(global.payScreenData.qr[index].amount)),
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
                      content: Text(
                          global.language("ต้องการยกเลิกรายการนี้จริงหรือไม่")),
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
                              global.payScreenData.qr.removeAt(index);
                              refreshEvent();
                            });
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        ),
      ),
    );
  }

  Column buildDetailsBlock({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
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

  void onKeyboardTap(String value) {
    setState(() {});
  }

  void promptPay(
      {required double amount, required PaymentProviderModel provider}) {
    refreshEvent();
    if (amount != 0.0) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: PayQrScreen(
                    context: context, provider: provider, amount: amount),
              );
            });
          }).then((value) {
        if (value) {
          if (value == true) {
            if (saveData(provider.paymentcode, provider.names[0].name)) {
              _descriptionController.text = '';
              _amount = 0.0;
              global.payScreenNumberPadText = "";
              global.payScreenNumberPadAmount = 0;
            }
          }
          refreshEvent();
        }
      });
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Column(children: [
                  Text(global.language('กรุณาบันทึกจำนวนเงินที่จะชำระ')),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: Text(
                      global.language("close"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ]),
              );
            });
          });
    }
  }

  Widget qrList(double amount) {
    double iconHeight = 100;
    double iconWidth = 100;

    List<PaymentProviderModel> providerList = [];
    providerList.addAll(global.qrPaymentProviderList);
    providerList.addAll(global.lugenPaymentProviderList);
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
        ),
        padding: const EdgeInsets.all(8),
        child: Wrap(spacing: 2, runSpacing: 2, children: [
          for (var provider in providerList)
            CommandButton(
                height: iconHeight,
                width: iconWidth,
                primaryColor: Colors.white,
                label: (provider.providercode.isEmpty)
                    ? "${provider.names[0].name} : ${provider.bookbankcode}"
                    : "${provider.providercode} : ${provider.names[0].name}",
                imgAssetPath:
                    ("assets/images/qrpay/${provider.paymentcode}.png")
                        .toLowerCase(),
                onPressed: () {
                  promptPay(amount: amount, provider: provider);
                })
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 4),
                child: (global.payScreenData.qr.isEmpty)
                    ? Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(children: [
                          Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4)),
                              ),
                              child: Center(
                                  child: Text(
                                "${global.language("รับชำระด้วย QR Code เต็มจำนวน")} : ${global.moneyFormat.format(diffAmount())} ${global.language("money_symbol")}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))),
                          qrList(diffAmount()),
                        ]))
                    : Container()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                formDetail(),
                Column(
                  children: <Widget>[
                    ...global.payScreenData.qr.map((detail) {
                      var index = global.payScreenData.qr.indexOf(detail);
                      return buildCard(index: index);
                    }).toList(),
                  ],
                ),
              ],
            )
          ],
        )));
  }
}
