// ignore_for_file: library_prefixes

import 'dart:developer' as dev;
import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:promptpay/promptpay.dart';
import 'dart:convert';
import 'package:dedepos/api/sync/sync_bill.dart';
import 'package:dedepos/bloc/pay_screen_bloc.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/features/pos/presentation/screens/pay/pay_cash.dart';
import 'package:dedepos/features/pos/presentation/screens/pay/pay_coupon.dart';
import 'package:dedepos/features/pos/presentation/screens/pay/pay_util.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_print.dart';
import 'package:dedepos/widgets/button.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/json/pos_process_model.dart';
import 'pay_credit_card.dart';
import 'pay_transfer.dart';
import 'pay_discount.dart';
import 'pay_cheque.dart';
import 'pay_qr.dart';
import 'pay_widget.dart';
import '../pos_util.dart' as posUtil;

class PayScreen extends StatefulWidget {
  final PosProcessModel posProcess;
  final int defaultTabIndex;

  const PayScreen(
      {Key? key, required this.posProcess, required this.defaultTabIndex})
      : super(key: key);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> with TickerProviderStateMixin {
  String _textInputCash = "";
  late TabController tabBarMenuController;
  double sumTotalPayAmount = 0;
  double diffAmount = 0;
  GlobalKey<PayCashWidgetState> posPayCashGlobalKey = GlobalKey();
  GlobalKey<PayQrWidgetState> posQrGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    tabBarMenuController = TabController(length: 8, vsync: this);
    tabBarMenuController.addListener(() {
      setState(() {
        global.payScreenNumberPadIsActive = false;
        dev.log("Selected Index: ${tabBarMenuController.index}");
      });
    });
    sendPayScreenCommandToCustomerDisplay();
    tabBarMenuController.index = widget.defaultTabIndex;
    Timer(const Duration(milliseconds: 200), () {
      reCalc();
      if (widget.defaultTabIndex == 2) {
        posQrGlobalKey.currentState!.promptPay(
            amount: diffAmount, provider: global.qrPaymentProviderList[0]);
      }
    });
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
      var url = "${global.customerDisplayDeviceList[index].ip}:5041";
      global.posHoldProcessResult[global.posHoldActiveNumber].posProcess
              .qr_code =
          PromptPay.generateQRData("0899223131",
              amount: global.posHoldProcessResult[global.posHoldActiveNumber]
                  .posProcess.total_amount
                  .toDouble());
      var jsonData = HttpPost(
          command: "pay_screen",
          data: jsonEncode(global
              .posHoldProcessResult[global.posHoldActiveNumber].posProcess
              .toJson()));
      global.postToServer(
          ip: url, jsonData: jsonEncode(jsonData.toJson()), callBack: () {});
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
                  child: NumPadButton(
                text: '7',
                callBack: () => {cashTextInputAdd("7")},
              )),
              Expanded(
                  child: NumPadButton(
                text: '8',
                callBack: () => {cashTextInputAdd("8")},
              )),
              Expanded(
                  child: NumPadButton(
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
                  child: NumPadButton(
                text: '4',
                callBack: () => {cashTextInputAdd("4")},
              )),
              Expanded(
                  child: NumPadButton(
                text: '5',
                callBack: () => {cashTextInputAdd("5")},
              )),
              Expanded(
                  child: NumPadButton(
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
                  child: NumPadButton(
                text: '1',
                callBack: () => {cashTextInputAdd("1")},
              )),
              Expanded(
                  child: NumPadButton(
                text: '2',
                callBack: () => {cashTextInputAdd("2")},
              )),
              Expanded(
                  child: NumPadButton(
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
                  child: NumPadButton(
                text: '0',
                callBack: () => {cashTextInputAdd("0")},
              )),
              Expanded(
                  child: NumPadButton(
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
                  child: NumPadButton(
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
                child: NumPadButton(
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
    String moneySymbol = global.language('money_symbol');
    double fontSize =
        (global.isDesktopScreen() || global.isTabletScreen()) ? 32 : 24;

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
            serviceLocator<Log>().error(e);
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
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                          global.moneyFormat
                              .format(widget.posProcess.total_amount),
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
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                          '${global.moneyFormat.format(sumTotalPayAmount)} $moneySymbol',
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
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                          '${global.moneyFormat.format(diffAmount)} $moneySymbol',
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
    if (posPayCashGlobalKey.currentState != null) {
      posPayCashGlobalKey.currentState!.setPayAmount(diffAmount);
    }
  }

  void payProcessSave() async {
    reCalc();
    await posUtil
        .saveBill(
            cashAmount: global.payScreenData.cash_amount,
            discountFormula: global.payScreenData.discount_formula,
            discountAmount: global.payScreenData.discount_amount)
        .then((value) async {
      if (value.docNumber.isNotEmpty) {
        printBill(value.docDate, value.docNumber);
        syncBillProcess();
        paySuccessDialog();
      }
    });
  }

  Widget paySummeryScreen() {
    String moneySymbol = global.language('money_symbol');
    reCalc();
    TextStyle textStyle = TextStyle(
      fontSize: (global.isTabletScreen() || global.isDesktopScreen()) ? 24 : 10,
    );
    List<Widget> list = [
      // รายละเอียด/รูปแบบ การชำระเงิน
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: global.posTheme.background, width: 2),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: global.posTheme.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    global.language("payment_channel"), // รูปแบบการชำระ
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          (global.isTabletScreen() || global.isDesktopScreen())
                              ? 24
                              : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Expanded(
                  child: Column(
                children: [
                  // หักส่วนลด
                  if (global.payScreenData.discount_amount != 0)
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(global.language('total_pay_amount_discount'),
                              style: textStyle),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                global.moneyFormat.format(
                                    global.payScreenData.discount_amount),
                                style: textStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(moneySymbol, style: textStyle),
                        ],
                      ),
                    ),
                  // คูปอง
                  if (sumCoupon() != 0)
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Text(global.language('total_pay_amount_coupon'),
                              style: textStyle),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                global.moneyFormat.format(sumCoupon()),
                                style: textStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(moneySymbol, style: textStyle),
                        ],
                      ),
                    ),
                  // ยอดชำระด้วยเงินสด
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(global.language('total_pay_amount_cash'),
                            style: textStyle),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              global.moneyFormat
                                  .format(global.payScreenData.cash_amount),
                              style: textStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(moneySymbol, style: textStyle),
                      ],
                    ),
                  ),
                  // ยอดชำระด้วยบัตรเครดิต
                  if (sumCreditCard() != 0)
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(global.language('total_pay_amount_card'),
                              style: textStyle),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                global.moneyFormat.format(sumCreditCard()),
                                style: textStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(moneySymbol, style: textStyle),
                        ],
                      ),
                    ),
                  // ยอดชำระด้วยการโอน
                  if (sumTransfer() != 0)
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(global.language('total_pay_amount_transfer'),
                              style: textStyle),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                global.moneyFormat.format(sumTransfer()),
                                style: textStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(moneySymbol, style: textStyle),
                        ],
                      ),
                    ),
                  // ยอดชำระด้วยเช็ค
                  if (sumCheque() != 0)
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(global.language('total_pay_amount_cheque'),
                              style: textStyle),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                global.moneyFormat.format(sumCheque()),
                                style: textStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(moneySymbol, style: textStyle),
                        ],
                      ),
                    ),
                  // ยอดชำระด้วย Wallet
                  if (sumQr() != 0)
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(global.language('total_pay_amount_wallet'),
                              style: textStyle),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                global.moneyFormat.format(sumQr()),
                                style: textStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(moneySymbol, style: textStyle),
                        ],
                      ),
                    ),
                ],
              )),

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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(global.language('total_pay_amount'), style: textStyle),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          global.moneyFormat.format(sumTotalPayAmount),
                          style:
                              textStyle.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(moneySymbol, style: textStyle),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      (global.isTabletScreen() || global.isDesktopScreen())
          ? const SizedBox(
              width: 10,
              height: 10,
            )
          : const SizedBox(
              width: 2,
              height: 2,
            ),
      // การชำระเงิน
      Expanded(
          child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: global.posTheme.background, width: 2),
          borderRadius: BorderRadius.circular(7.0),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: global.posTheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
              ),
              child: Center(
                child: Text(
                  global.language("pay_channel"), // การชำระเงิน
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        (global.isTabletScreen() || global.isDesktopScreen())
                            ? 24
                            : 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        // ร่วมเงินทั้งสิ้น
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(global.language('total_amount'),
                                style: textStyle),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  global.moneyFormat
                                      .format(widget.posProcess.total_amount),
                                  style: textStyle.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(moneySymbol, style: textStyle),
                          ],
                        ),
                        // ยอดรวมชำระทั้งสิ้น
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(global.language('total_pay_amount'),
                                style: textStyle),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  global.moneyFormat.format(sumTotalPayAmount),
                                  style: textStyle.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(moneySymbol, style: textStyle),
                          ],
                        ),
                        // ยอดคงเหลือหรือปัดเศษ
                        // if (_diffAmount != 0)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(global.language('total_pay_amount_diff'),
                                style: textStyle),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  global.moneyFormat.format(diffAmount),
                                  style: textStyle.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(moneySymbol, style: textStyle),
                          ],
                        ),
                      ],
                    ))),
            Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        global.sendProcessToCustomerDisplay();
                        Navigator.pop(context);
                      },
                      child: Text(
                        global.language("back"),
                        style: TextStyle(
                          fontSize: (global.isTabletScreen() ||
                                  global.isDesktopScreen())
                              ? 32.0
                              : 12,
                          fontWeight: FontWeight.bold,
                          shadows: const <Shadow>[
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 3.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: (global.isTabletScreen() || global.isDesktopScreen())
                        ? 10
                        : 5,
                    height:
                        (global.isTabletScreen() || global.isDesktopScreen())
                            ? 10
                            : 5,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async {
                        payProcessSave();
                      },
                      child: Text(
                        global.language("pay"),
                        style: TextStyle(
                          fontSize: (global.isTabletScreen() ||
                                  global.isDesktopScreen())
                              ? 32.0
                              : 12,
                          fontWeight: FontWeight.bold,
                          shadows: const <Shadow>[
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 3.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    ];
    if (global.isTabletScreen() || global.isDesktopScreen()) {
      return Column(
        children: list,
      );
    } else {
      return IntrinsicHeight(
          child: Row(
        children: list,
      ));
    }
  }

  Widget commandButton(
      {required int index,
      required Function onPressed,
      String label = "",
      IconData? icon}) {
    return Expanded(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: (index == tabBarMenuController.index)
                    ? Colors.green
                    : Colors.blue,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.only(
                    left: 2, right: 2, top: 0, bottom: 0)),
            onPressed: () {
              onPressed();
            },
            child: (icon != null)
                ? FittedBox(
                    fit: BoxFit.fill,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            icon,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            label,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(fontSize: 12),
                          )
                        ]))
                : FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(fontSize: 12),
                    ),
                  )));
  }

  Widget commandWidget() {
    List<Widget> commands = [
      if (global.posUseSaleType)
        commandButton(
          index: 0,
          label: global.language("cash"),
          onPressed: () {
            tabBarMenuController.index = 0;
          },
        ),
      commandButton(
        index: 1,
        icon: FontAwesomeIcons.walkieTalkie,
        label: global.language("discount"),
        onPressed: () {
          tabBarMenuController.index = 1;
        },
      ),
      commandButton(
        index: 2,
        icon: FontAwesomeIcons.cashRegister,
        label: global.language('qr_code'),
        onPressed: () {
          tabBarMenuController.index = 2;
        },
      ),
      commandButton(
        index: 3,
        icon: FontAwesomeIcons.user,
        label: global.language('credit_card'),
        onPressed: () {
          tabBarMenuController.index = 3;
        },
      ),
      commandButton(
        index: 4,
        icon: FontAwesomeIcons.user,
        label: global.language('money_transfer'),
        onPressed: () {
          tabBarMenuController.index = 4;
        },
      ),
      commandButton(
          index: 5,
          icon: Icons.restart_alt,
          label: global.language('cheque'),
          onPressed: () {
            tabBarMenuController.index = 5;
          }),
      commandButton(
          index: 6,
          icon: Icons.print,
          label: global.language('coupon'),
          onPressed: () {
            tabBarMenuController.index = 6;
          }),
      commandButton(
          index: 7,
          icon: Icons.print,
          label: global.language('credit'),
          onPressed: () {
            tabBarMenuController.index = 7;
          }),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      int rowNumber = 1;
      if (constraints.maxWidth < 500) rowNumber = 2;
      if (constraints.maxWidth < 200) rowNumber = 3;
      List<Widget> columns = [];
      int itemCount = 0;
      int itemPerRow = (commands.length / rowNumber).ceil();
      for (int rowIndex = 0; rowIndex < rowNumber; rowIndex++) {
        List<Widget> rows = [];
        for (int columnIndex = 0; columnIndex < itemPerRow; columnIndex++) {
          if (itemCount < commands.length) {
            if (columnIndex != 0) {
              rows.add(const SizedBox(
                width: 4,
              ));
            }
            rows.add(commands[itemCount]);
            itemCount++;
          }
        }
        if (rowIndex != 0) {
          columns.add(const SizedBox(
            height: 4,
          ));
        }
        columns.add(IntrinsicHeight(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: rows)));
      }
      return Container(
          margin: const EdgeInsets.all(2),
          child: Column(
            children: columns,
          ));
    });
  }

  Widget payDetailScreen(BuildContext blocContext) {
    List<Widget> tabViewList = [];
    tabViewList.add(PayCashWidget(
      blocContext: blocContext,
      key: posPayCashGlobalKey,
    ));
    tabViewList.add(PayDiscountWidget(
        posProcess: widget.posProcess, blocContext: blocContext));
    tabViewList.add(PayQrWidget(
        key: posQrGlobalKey,
        posProcess: widget.posProcess,
        blocContext: blocContext));
    tabViewList.add(
        PayCreditCard(posProcess: widget.posProcess, blocContext: blocContext));
    tabViewList.add(
        PayTransfer(posProcess: widget.posProcess, blocContext: blocContext));
    tabViewList.add(
        PayCheque(posProcess: widget.posProcess, blocContext: blocContext));
    tabViewList.add(
        PayCoupon(posProcess: widget.posProcess, blocContext: blocContext));
    tabViewList.add(
        PayCoupon(posProcess: widget.posProcess, blocContext: blocContext));

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
            child: Column(children: [
              commandWidget(),
              Expanded(
                  child: DefaultTabController(
                      length: 7,
                      child: Scaffold(
                          backgroundColor: Colors.blue.shade100,
                          resizeToAvoidBottomInset: false,
                          body: TabBarView(
                              controller: tabBarMenuController,
                              children: tabViewList))))
            ])));
  }

  void numberPadTextAdd(String word) {
    setState(() {
      switch (global.payScreenNumberPadWidget) {
        case PayScreenNumberPadWidgetEnum.number:
          global.payScreenNumberPadText = global.payScreenNumberPadText + word;
          global.payScreenNumberPadAmount =
              global.calcTextToNumber(global.payScreenNumberPadText);
          break;
        case PayScreenNumberPadWidgetEnum.text:
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
      case PayScreenNumberPadWidgetEnum.number:
        result = global.moneyFormat.format(global.payScreenNumberPadAmount);
        break;
      case PayScreenNumberPadWidgetEnum.text:
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
                      child: NumPadButton(
                    text: '7',
                    callBack: () => {numberPadTextAdd("7")},
                  )),
                  Expanded(
                      child: NumPadButton(
                    text: '8',
                    callBack: () => {numberPadTextAdd("8")},
                  )),
                  Expanded(
                      child: NumPadButton(
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
                      child: NumPadButton(
                    text: '4',
                    callBack: () => {numberPadTextAdd("4")},
                  )),
                  Expanded(
                      child: NumPadButton(
                    text: '5',
                    callBack: () => {numberPadTextAdd("5")},
                  )),
                  Expanded(
                      child: NumPadButton(
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
                      child: NumPadButton(
                    text: '1',
                    callBack: () => {numberPadTextAdd("1")},
                  )),
                  Expanded(
                      child: NumPadButton(
                    text: '2',
                    callBack: () => {numberPadTextAdd("2")},
                  )),
                  Expanded(
                      child: NumPadButton(
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
                      child: NumPadButton(
                    text: '0',
                    callBack: () => {numberPadTextAdd("0")},
                  )),
                  Expanded(
                      child: NumPadButton(
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
                      child: NumPadButton(
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
                    child: NumPadButton(
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
          child: (global.isTabletScreen() || global.isDesktopScreen())
              ? Stack(children: [
                  Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(children: <Widget>[
                        Expanded(child: payDetailScreen(blocContext)),
                        const SizedBox(width: 5),
                        Expanded(child: paySummeryScreen()),
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
                                global.payScreenNumberPadLeft =
                                    details.offset.dx;
                                global.payScreenNumberPadTop =
                                    details.offset.dy;
                              });
                            },
                          ))
                      : Container()
                ])
              : Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(children: <Widget>[
                    Expanded(child: payDetailScreen(blocContext)),
                    const SizedBox(height: 5),
                    paySummeryScreen(),
                  ])),
        ),
      );
    });
  }
}
