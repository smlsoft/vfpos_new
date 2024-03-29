import 'package:dedepos/global_model.dart';
import 'package:dedepos/bloc/pay_screen_bloc.dart';
import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/features/pos/presentation/screens/pay/pay_qr_screen.dart';
import 'package:dedepos/features/pos/presentation/screens/pay/pay_util.dart';
import 'package:dedepos/widgets/button.dart';
import 'package:dedepos/widgets/numpad.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/model/system/pos_pay_model.dart';
import 'package:get/get.dart';

class PayQrWidget extends StatefulWidget {
  final PosHoldProcessModel posProcess;
  final BuildContext blocContext;

  const PayQrWidget({super.key, required this.posProcess, required this.blocContext});

  @override
  PayQrWidgetState createState() => PayQrWidgetState();
}

class PayQrWidgetState extends State<PayQrWidget> {
  final descriptionController = TextEditingController();
  double payAmount = 0;
  GlobalKey widgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void refreshEvent() {
    widget.blocContext.read<PayScreenBloc>().add(PayScreenRefresh());
  }

  bool saveData({required String providerCode, required String providerName, required payAmount, required String logo}) {
    if (payAmount > 0) {
      global.payScreenData.qr.add(PayQrModel(
          provider_code: providerCode, provider_name: providerName, description: descriptionController.text, amount: double.parse(payAmount.toStringAsFixed(2)), logo: logo));
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
          Text(global.language('qr_code_split')), // กรณีชำระด้วย QR Code มากกว่า 1 รายการ (แบ่งจ่าย)
          Container(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: Row(children: [
              Expanded(
                  flex: 2,
                  child: TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: global.language('description'), // 'รายละเอียด'
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: SizedBox(
                      key: widgetKey,
                      width: double.infinity,
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
                                          payAmount = double.tryParse(value) ?? 0.0;
                                        });
                                      }),
                                    ));
                              },
                            );
                            refreshEvent();
                          },
                          child: Column(
                            children: [
                              Text(
                                global.language('amount'),
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.right,
                              ),
                              Text(global.moneyFormatAndDot.format(payAmount), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
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
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                        color: Colors.green,
                      ),
                      child: Center(
                        child: Text('${global.language('wallet_amount')} : ${global.moneyFormatAndDot.format(payAmount)} ${global.language('money_symbol')}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      )),
                  qrList(payAmount),
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
                    (global.payScreenData.qr[index].logo.isNotEmpty)
                        ? Image.network(
                            global.payScreenData.qr[index].logo,
                            height: 40,
                          )
                        : Container(),
                    Text(global.payScreenData.qr[index].provider_name)
                  ],
                ),
                buildDetailsBlock(
                  label: global.language('qr_description'),
                  value: global.payScreenData.qr[index].description,
                ),
                buildDetailsBlock(label: global.language('qr_amount'), value: global.moneyFormatAndDot.format(global.payScreenData.qr[index].amount)),
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
                      content: Text(global.language("delete_confirm")),
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
          style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.green.shade500, fontSize: 18, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  void onKeyboardTap(String value) {
    setState(() {});
  }

  void promptPay({required double amount, required ProfileQrPaymentModel provider}) {
    refreshEvent();
    if (amount != 0.0) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: PayQrScreen(context: context, provider: provider, amount: amount),
              );
            });
          }).then((value) {
        if (value) {
          if (value == true) {
            if (saveData(providerCode: provider.qrcode, providerName: provider.qrnames[0].name, payAmount: amount, logo: provider.logo)) {
              descriptionController.text = '';
              payAmount = 0.0;
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
                  Text(global.language('money_amount')),
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

    List<ProfileQrPaymentModel> providerList = [];
    providerList.addAll(global.posConfig.qrcodes ?? []);
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight: Radius.circular(6)),
        ),
        padding: const EdgeInsets.all(8),
        child: Wrap(spacing: 2, runSpacing: 2, children: [
          for (var provider in providerList)
            CommandButton(
                height: iconHeight,
                width: iconWidth,
                primaryColor: Colors.white,
                label: global.getNameFromLanguage(provider.qrnames, global.userScreenLanguage),
                imgNetworkPath: provider.logo,
                onPressed: () {
                  promptPay(amount: amount, provider: provider);
                })
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return (global.posConfig.qrcodes!.isNotEmpty)
        ? Container(
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
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "${global.language("pay_qr_code_full_amount")} : ${global.moneyFormatAndDot.format(diffAmount())} ${global.language("money_symbol")}",
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
            )))
        : Container();
  }
}
