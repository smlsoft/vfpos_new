import 'dart:developer' as dev;
import 'package:dedepos/api/network/server.dart';
import 'package:http/http.dart' as http;
import 'package:promptpay/promptpay.dart';
import 'dart:convert';
import 'package:dedepos/api/network/server.dart' as network;
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:dedepos/api/sync/sync_bill.dart';
import 'package:dedepos/bloc/pay_screen_bloc.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/pos_screen/pay/pay_cash.dart';
import 'package:dedepos/pos_screen/pay/pay_coupon.dart';
import 'package:dedepos/pos_screen/pay/pay_util.dart';
import 'package:dedepos/pos_screen/pos_print.dart';
import 'package:dedepos/pos_screen/pos_screen.dart';
import 'package:dedepos/widgets/roundpaymenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:dedepos/pos_screen/pos_process.dart';
import 'package:dedepos/widgets/button.dart';
import 'package:dedepos/widgets/numpad.dart';
import 'dart:async';
import 'dart:io';
import 'package:dedepos/model/pos_pay_struct.dart';
import 'package:dedepos/model/json/struct.dart';
import 'package:dedepos/model/find/find_item_struct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:dedepos/bloc/find_item_by_code_name_barcode_bloc.dart';
import 'package:dedepos/services/pos_button.dart';
import 'package:dedepos/services/result_display.dart';
import 'package:dedepos/services/menu_button.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/api/rest_api.dart';
import 'package:dedepos/widgets/numpad.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dedepos/model/json/pos_process_struct.dart';
import 'package:flutter_svg/svg.dart';
import 'pay_credit_card.dart';
import 'pay_transfer.dart';
import 'pay_discount.dart';
import 'pay_cheque.dart';
import 'pay_qr.dart';
import 'pay_widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../pos_util.dart' as posUtil;

class PayScreen extends StatefulWidget {
  final PosProcessStruct posProcess;

  const PayScreen({Key? key, required this.posProcess}) : super(key: key);

  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> with TickerProviderStateMixin {
  String _textInputCash = "";
  late TabController tabBarMenuController;
  double sumTotalPayAmount = 0;
  double diffAmount = 0;

  @override
  void initState() {
    super.initState();
    if (global.posVersion == global.PosVersionEnum.pos ||
        global.posVersion == global.PosVersionEnum.restaurant) {
      tabBarMenuController = TabController(length: 7, vsync: this);
    } else {
      tabBarMenuController = TabController(length: 5, vsync: this);
    }
    tabBarMenuController.addListener(() {
      setState(() {
        global.payScreenNumberPadIsActive = false;
        dev.log("Selected Index: " + tabBarMenuController.index.toString());
      });
    });
    sendPayScreenCommandToCustomerDisplay();
  }

  @override
  void dispose() {
    super.dispose();
    global.payScreenNumberPadIsActive = false;
    tabBarMenuController.dispose();
  }

  Future<void> sendPayScreenCommandToCustomerDisplay() async {
    for (int index = 0;
        index < global.customerDisplayDeviceList.length;
        index++) {
      dev.log(
          "sendPayScreenCommandToCustomerDisplay : ${global.customerDisplayDeviceList[index].ip}");
      var url = "http://${global.customerDisplayDeviceList[index].ip}:5041";
      global.posProcessResult.qr_code = PromptPay.generateQRData("0899223131",
          amount: global.posProcessResult.total_amount.toDouble());
      var jsonData = HttpPost(
          command: "pay_screen",
          data: jsonEncode(global.posProcessResult.toJson()));
      global.sendToServer(url, jsonEncode(jsonData.toJson()));
    }
  }

  Widget moneyButton(double value) {
    String imagePath =
        ('assets/images/moneythai${value.toStringAsFixed(0)}.gif')
            .toLowerCase();
    return PayButton(
        primary: Colors.blue[400],
        onPressed: () {
          setState(() {
            global.payScreenData.cash_amount =
                global.payScreenData.cash_amount + value;
          });
        },
        label: "+${value.toStringAsFixed(0)}",
        child: Image(
          image: AssetImage(imagePath),
          width: 60,
        ));
  }

  void cashTextInputAdd(String word) {
    setState(() {
      _textInputCash = _textInputCash + word;
      global.payScreenData.cash_amount =
          global.calcTextToNumber(_textInputCash);
    });
  }

  Widget cashNumberPad() {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  child: NumpadButton(
                text: '7',
                callBack: () => {cashTextInputAdd("7")},
              )),
              Expanded(
                  child: NumpadButton(
                text: '8',
                callBack: () => {cashTextInputAdd("8")},
              )),
              Expanded(
                  child: NumpadButton(
                text: '9',
                callBack: () => {cashTextInputAdd("9")},
              )),
              // Expanded(
              //   child: NumpadButton(
              //     text: '+',
              //     callBack: () => {textInputAdd("+")},
              //   ),
              // ),
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
                callBack: () => {cashTextInputAdd("4")},
              )),
              Expanded(
                  child: NumpadButton(
                text: '5',
                callBack: () => {cashTextInputAdd("5")},
              )),
              Expanded(
                  child: NumpadButton(
                text: '6',
                callBack: () => {cashTextInputAdd("6")},
              )),
              // Expanded(
              //   child: NumpadButton(
              //     text: 'C',
              //     callBack: () => {
              //       setState(() {
              //         _textInput = "";
              //         _pay.cash_amount = 0;
              //       })
              //     },
              //   ),
              // ),
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
                callBack: () => {cashTextInputAdd("1")},
              )),
              Expanded(
                  child: NumpadButton(
                text: '2',
                callBack: () => {cashTextInputAdd("2")},
              )),
              Expanded(
                  child: NumpadButton(
                text: '3',
                callBack: () => {cashTextInputAdd("3")},
              )),
              // Expanded(
              //   child: NumpadButton(
              //     textAndIconColor: Colors.black,
              //     icon: Icons.backspace,
              //     callBack: () => {
              //       if (_textInput.isNotEmpty)
              //         {
              //           setState(() {
              //             _textInput = _textInput.substring(
              //                 0, _textInput.length - 1);
              //             _pay.cash_amount =
              //                 global.calcTextToNumber(_textInput);
              //           })
              //         }
              //     },
              //   ),
              // ),
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
                callBack: () => {cashTextInputAdd("0")},
              )),
              Expanded(
                  child: NumpadButton(
                text: '.',
                callBack: () => {cashTextInputAdd(".")},
              )),
              // Expanded(
              //   child: NumpadButton(
              //     icon: Icons.save_sharp,
              //     textAndIconColor: Colors.white,
              //     color: Colors.green,
              //     callBack: () => {
              //       setState(() {
              //         _pay.cash_amount =
              //             global.calcTextToNumber(_textInput);
              //         global.playSound(
              //             sound: global.SoundEnum.beep,
              //             word: _pay.cash_amount.toString() +
              //                 "..\"" +
              //                 "pos".tr(gender: "money_symbol"));
              //         _textInput = "";
              //       })
              //     },
              //   ),
              // ),
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
                callBack: () => {
                  if (_textInputCash.isNotEmpty)
                    {
                      setState(() {
                        _textInputCash = _textInputCash.substring(
                            0, _textInputCash.length - 1);
                        global.payScreenData.cash_amount =
                            global.calcTextToNumber(_textInputCash);
                      })
                    }
                },
              )),
              Expanded(
                child: NumpadButton(
                  text: 'C',
                  color: Colors.grey.shade400,
                  callBack: () => {
                    setState(() {
                      _textInputCash = "";
                      global.payScreenData.cash_amount = 0;
                    })
                  },
                ),
              ),
              // Expanded(
              //   child: NumpadButton(
              //     icon: Icons.save_sharp,
              //     textAndIconColor: Colors.white,
              //     color: Colors.green,
              //     callBack: () => {
              //       setState(() {
              //         _pay.cash_amount =
              //             global.calcTextToNumber(_textInput);
              //         global.playSound(
              //             sound: global.SoundEnum.beep,
              //             word: _pay.cash_amount.toString() +
              //                 "..\"" +
              //                 "pos".tr(gender: "money_symbol"));
              //         _textInput = "";
              //       })
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  void paySuccessDialog() {
    double fontSize = 32;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 30), () {
          try {
            // ปิดหน้าจอเตือน
            Navigator.of(context).pop(true);
            // ปิดหน้าจอ pay และ Clear ข้อมูล เริ่มขายใหม่
            Navigator.pop(context, true);
          } catch (e) {
            print(e);
          }
        });
        return Center(
          child: Container(
            width: 800,
            height: 500,
            padding: const EdgeInsets.all(50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: global.posTheme.background,
            ),
            child: Column(
              children: [
                Expanded(
                    child: Column(children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          global.language("total_amount_product_service"),
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: fontSize,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${global.moneyFormat.format(widget.posProcess.total_amount)} ${global.language("money_symbol")}',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: fontSize,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          global.language("total_payment_amount"),
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: fontSize,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${global.moneyFormat.format(sumTotalPayAmount)} ${global.language('money_symbol')}',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: fontSize,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          global.language("money_change"),
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: fontSize,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${global.moneyFormat.format(diffAmount)} ${global.language('money_symbol')}',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: fontSize,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  )
                ])),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          // ปิดหน้าจอเตือน
                          Navigator.of(context).pop(true);
                          // ปิดหน้าจอ pay และ Clear ข้อมูล เริ่มขายใหม่
                          Navigator.pop(context, true);
                        },
                        child: Text(global.language("ok"),
                            style: const TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 50,
                              color: Colors.white,
                            )))),
              ],
            ),
          ),
        );
      },
    );
  }

  void reCalc() {
    sumTotalPayAmount = global.payScreenData.cash_amount +
        sumCoupon() +
        sumCreditCard() +
        sumTransfer() +
        sumCheque() +
        sumQr() +
        global.payScreenData.discount_amount;
    diffAmount = widget.posProcess.total_amount - sumTotalPayAmount;
  }

  void payProcessSave() async {
    reCalc();
    await posUtil
        .saveBill(
            cashAmount: global.payScreenData.cash_amount,
            discountFormula: global.payScreenData.discount_formula,
            discountAmount: global.payScreenData.discount_amount)
        .then((docNumber) async {
      print(docNumber);
      if (docNumber.isNotEmpty) {
        printBill(docNumber);
        syncBillProcess();
        paySuccessDialog();
      }
    });
  }

  Widget paySummeryScreen() {
    reCalc();
    TextStyle textStyle = const TextStyle(
      fontSize: 18,
    );
    return Column(
      children: [
        // รายละเอียด/รูปแบบ การชำระเงิน
        Expanded(
          child: Container(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: global.posTheme.background, width: 2),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: global.posTheme.background,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          global.language("รูปแบบการชำระ"),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // หักส่วนลด
                            if (global.payScreenData.discount_amount != 0)
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Text(
                                        global.language(
                                            'total_pay_amount_discount'),
                                        style: textStyle),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${global.moneyFormat.format(global.payScreenData.discount_amount)} ${global.language('money_symbol')}',
                                          style: textStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // คูปอง
                            if (sumCoupon() != 0)
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Text(
                                        global.language(
                                            'total_pay_amount_coupon'),
                                        style: textStyle),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${global.moneyFormat.format(sumCoupon())} ${global.language('money_symbol')}',
                                          style: textStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // ยอดชำระด้วยเงินสด
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Text(global.language('total_pay_amount_cash'),
                                      style: textStyle),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${global.moneyFormat.format(global.payScreenData.cash_amount)} ${global.language('money_symbol')}',
                                        style: textStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // ยอดชำระด้วยบัตรเครดิต
                            if (sumCreditCard() != 0)
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Text(
                                        global
                                            .language('total_pay_amount_card'),
                                        style: textStyle),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${global.moneyFormat.format(sumCreditCard())} ${global.language('money_symbol')}',
                                          style: textStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // ยอดชำระด้วยการโอน
                            if (sumTransfer() != 0)
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Text(
                                        global.language(
                                            'total_pay_amount_transfer'),
                                        style: textStyle),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${global.moneyFormat.format(sumTransfer())} ${global.language('money_symbol')}',
                                          style: textStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // ยอดชำระด้วยเช็ค
                            if (sumCheque() != 0)
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Text(
                                        global.language(
                                            'total_pay_amount_cheque'),
                                        style: textStyle),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${global.moneyFormat.format(sumCheque())} ${global.language('money_symbol')}',
                                          style: textStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // ยอดชำระด้วย Wallet
                            if (sumQr() != 0)
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Text(
                                        global.language(
                                            'total_pay_amount_wallet'),
                                        style: textStyle),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${global.moneyFormat.format(sumQr())} ${global.language('money_symbol')}',
                                          style: textStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    //ยอดชำระรวมทั้งสิ้น
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade300,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(4.0),
                          bottomRight: Radius.circular(4.0),
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text(global.language('total_pay_amount'),
                              style: textStyle),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${global.moneyFormat.format(sumTotalPayAmount)} ${global.language('money_symbol')}',
                                style: textStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
        // การชำระเงิน
        Container(
            padding: const EdgeInsets.only(left: 4, right: 4, top: 4),
            child: SizedBox(
              height: (MediaQuery.of(context).size.height / 100) * 40,
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: global.posTheme.background, width: 2),
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: global.posTheme.background,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          global.language("การชำระเงิน"),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // ร่วมเงินทั้งสิ้น
                            Container(
                              padding: const EdgeInsets.all(5),
                              // color: Colors.green,
                              child: Row(
                                children: [
                                  Text(global.language('total_amount'),
                                      style: textStyle),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${global.moneyFormat.format(widget.posProcess.total_amount)} ${global.language('money_symbol')}',
                                        style: textStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // ยอดรวมชำระทั้งสิ้น
                            Container(
                              padding: const EdgeInsets.all(5),
                              // color: Colors.blue.shade200,
                              child: Row(
                                children: [
                                  Text(global.language('total_pay_amount'),
                                      style: textStyle),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${global.moneyFormat.format(sumTotalPayAmount)} ${global.language('money_symbol')}',
                                        style: textStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // ยอดคงเหลือหรือปัดเศษ
                            // if (_diffAmount != 0)
                            Container(
                              padding: const EdgeInsets.all(5),
                              // color: Colors.yellowAccent,
                              child: Row(
                                children: [
                                  Text(global.language('total_pay_amount_diff'),
                                      style: textStyle),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${global.moneyFormat.format(diffAmount)} ${global.language('money_symbol')}',
                                        style: textStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              onPressed: () async {
                                network.sendProcessToCustomerDisplay();

                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  global.language("back"),
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            )),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              onPressed: () async {
                                payProcessSave();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  global.language("pay"),
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget payDetailScreen(BuildContext blocContext) {
    List<Widget> tabBarList = [];
    List<Widget> tabViewList = [];
    {
      tabBarList
          .add(Text(global.language('cash'), textAlign: TextAlign.center));
      tabViewList.add(PayCashWidget(blocContext: blocContext));
    }
    {
      tabBarList
          .add(Text(global.language('discount'), textAlign: TextAlign.center));
      tabViewList.add(PayDiscountWidget(
          posProcess: widget.posProcess, blocContext: blocContext));
    }
    {
      tabBarList
          .add(Text(global.language('qr_code'), textAlign: TextAlign.center));
      tabViewList.add(
          PayQrWidget(posProcess: widget.posProcess, blocContext: blocContext));
    }
    {
      tabBarList.add(
          Text(global.language('credit_card'), textAlign: TextAlign.center));
      tabViewList.add(PayCreditCard(
          posProcess: widget.posProcess, blocContext: blocContext));
    }
    {
      tabBarList.add(
          Text(global.language('money_transfer'), textAlign: TextAlign.center));
      tabViewList.add(
          PayTransfer(posProcess: widget.posProcess, blocContext: blocContext));
    }
    if (global.posVersion == global.PosVersionEnum.pos ||
        global.posVersion == global.PosVersionEnum.restaurant) {
      {
        tabBarList
            .add(Text(global.language('cheque'), textAlign: TextAlign.center));
        tabViewList.add(
            PayCheque(posProcess: widget.posProcess, blocContext: blocContext));
      }
      {
        tabBarList
            .add(Text(global.language('coupon'), textAlign: TextAlign.center));
        tabViewList.add(
            PayCoupon(posProcess: widget.posProcess, blocContext: blocContext));
      }
    }

    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
            padding: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(7),
            ),
            child: DefaultTabController(
                length: 7,
                child: Scaffold(
                    backgroundColor: Colors.blue.shade100,
                    resizeToAvoidBottomInset: false,
                    body: Column(children: [
                      Container(
                          height: 50,
                          padding: const EdgeInsets.only(bottom: 4),
                          child: ColoredBox(
                              color: Colors.blue,
                              child: TabBar(
                                controller: tabBarMenuController,
                                labelColor: Colors.black,
                                indicatorColor: Colors.blue.shade100,
                                indicator: BoxDecoration(
                                    color: Colors.blue.shade300,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4))),
                                tabs: tabBarList,
                              ))),
                      Expanded(
                          child: TabBarView(
                              controller: tabBarMenuController,
                              children: tabViewList))
                    ])))));
  }

  void numberPadTextAdd(String word) {
    setState(() {
      switch (global.payScreenNumberPadWidget) {
        case payScreenNumberPadWidgetEnum.number:
          global.payScreenNumberPadText = global.payScreenNumberPadText + word;
          global.payScreenNumberPadAmount =
              global.calcTextToNumber(global.payScreenNumberPadText);
          break;
        case payScreenNumberPadWidgetEnum.text:
          global.payScreenNumberPadText = global.payScreenNumberPadText + word;
          break;
      }
    });
    global.numberPadCallBack.call();
  }

  Widget numberPadWidget() {
    double fontSize = 24;
    late String result;
    switch (global.payScreenNumberPadWidget) {
      case payScreenNumberPadWidgetEnum.number:
        result = global.moneyFormat.format(global.payScreenNumberPadAmount);
        break;
      case payScreenNumberPadWidgetEnum.text:
        result = global.payScreenNumberPadText;
        break;
    }
    return Container(
        width: 250,
        height: 350,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 2),
                color: Colors.blueGrey.shade200,
                spreadRadius: 4,
                blurRadius: 4)
          ],
        ),
        child: Column(
          children: [
            Padding(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
                child: Container(
                  height: 50,
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
                    child: Text(result,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            shadows: const [
                              Shadow(
                                  offset: Offset(-1, -1), color: Colors.white),
                              Shadow(
                                  offset: Offset(1, -1), color: Colors.white),
                              Shadow(offset: Offset(1, 1), color: Colors.white),
                              Shadow(
                                  offset: Offset(-1, 1), color: Colors.white),
                            ])),
                  ),
                )),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      child: NumpadButton(
                    text: '7',
                    callBack: () => {numberPadTextAdd("7")},
                  )),
                  Expanded(
                      child: NumpadButton(
                    text: '8',
                    callBack: () => {numberPadTextAdd("8")},
                  )),
                  Expanded(
                      child: NumpadButton(
                    text: '9',
                    callBack: () => {numberPadTextAdd("9")},
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
                    callBack: () => {numberPadTextAdd("4")},
                  )),
                  Expanded(
                      child: NumpadButton(
                    text: '5',
                    callBack: () => {numberPadTextAdd("5")},
                  )),
                  Expanded(
                      child: NumpadButton(
                    text: '6',
                    callBack: () => {numberPadTextAdd("6")},
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
                    callBack: () => {numberPadTextAdd("1")},
                  )),
                  Expanded(
                      child: NumpadButton(
                    text: '2',
                    callBack: () => {numberPadTextAdd("2")},
                  )),
                  Expanded(
                      child: NumpadButton(
                    text: '3',
                    callBack: () => {numberPadTextAdd("3")},
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
                    callBack: () => {numberPadTextAdd("0")},
                  )),
                  Expanded(
                      child: NumpadButton(
                    text: '.',
                    callBack: () => {
                      if (!global.payScreenNumberPadText.contains('.'))
                        numberPadTextAdd(
                            (global.payScreenNumberPadText.isNotEmpty)
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
                      setState(() {
                        if (global.payScreenNumberPadText.isNotEmpty) {
                          global.payScreenNumberPadText =
                              global.payScreenNumberPadText.substring(
                                  0, global.payScreenNumberPadText.length - 1);
                          global.payScreenNumberPadAmount = global
                              .calcTextToNumber(global.payScreenNumberPadText);
                          global.numberPadCallBack.call();
                        }
                      });
                    },
                  )),
                  Expanded(
                    child: NumpadButton(
                      text: 'C',
                      color: Colors.grey.shade400,
                      callBack: () {
                        setState(() {
                          global.payScreenNumberPadText = "";
                          global.payScreenNumberPadAmount = 0;
                          global.numberPadCallBack.call();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    reCalc();
    return BlocBuilder<PayScreenBloc, PayScreenState>(
        builder: (blocContext, state) {
      if (state is PayScreenRefresh) {
        blocContext.read<PayScreenBloc>().add(PayScreenSuccess());
      }
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Stack(children: [
          Padding(
              padding: const EdgeInsets.all(4),
              child: Row(children: <Widget>[
                Expanded(flex: 4, child: payDetailScreen(blocContext)),
                Expanded(flex: 2, child: paySummeryScreen()),
              ])),
          (global.payScreenNumberPadIsActive)
              ? Positioned(
                  left: global.payScreenNumberPadLeft,
                  top: global.payScreenNumberPadTop,
                  child: LongPressDraggable(
                    feedback: numberPadWidget(),
                    child: numberPadWidget(),
                    onDragEnd: (details) {
                      setState(() {
                        global.payScreenNumberPadLeft = details.offset.dx;
                        global.payScreenNumberPadTop = details.offset.dy;
                      });
                    },
                  ))
              : Container()
        ])),
      );
    });
  }
}
