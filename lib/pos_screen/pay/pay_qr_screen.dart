import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/system/bank_and_wallet_model.dart';
import 'package:dedepos/model/objectbox/bank_and_wallet_struct.dart';
import 'package:flutter/material.dart';
import 'package:lugentpayment/lugentpay.dart';
import 'package:lugentpayment/qrpaymentresponse.dart';
import 'package:promptpay/promptpay.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:dedepos/model/system/payment_mode.dart';

class PayQrScreen extends StatefulWidget {
  final PaymentProviderModel provider;
  final double amount;
  final BuildContext context;

  const PayQrScreen(
      {Key? key,
      required this.provider,
      required this.amount,
      required this.context})
      : super(key: key);

  @override
  _PayQrScreenState createState() => _PayQrScreenState();
}

class _PayQrScreenState extends State<PayQrScreen>
    with TickerProviderStateMixin {
  var promptPayDataWithAmount = "0899223131";
  final countDownController = CountDownController();
  String qrCodePayDataString = "";

  Future<QRPaymentResponse> qrLugentPromptPay() async {
    // Prompay ลูเจ้นท์ ไทย
    LugentPay lugentPay = LugentPay.InitDemoInstance();
    QRPaymentResponse qrPayment =
        await lugentPay.CreateThaiQRPaymentTransaction(
            lugentPay.CreateReferenceWithUnixTime("SMLINV"),
            "SMLSOFT",
            Decimal.parse(widget.amount.toString()),
            "");
    return qrPayment;
  }

  Future<QRPaymentResponse> qrLugentAliPay() async {
    // Prompay ลูเจ้นท์ ไทย
    LugentPay lugentPay = LugentPay.InitDemoInstance();
    QRPaymentResponse qrPayment = await lugentPay.CreateAliPayTransaction(
        lugentPay.CreateReferenceWithUnixTime("SMLINV"),
        "SMLSOFT",
        Decimal.parse(widget.amount.toString()),
        "");
    return qrPayment;
  }

  Future<QRPaymentResponse> qrLugentTrueMoney() async {
    // Prompay ลูเจ้นท์ ไทย
    LugentPay lugentPay = LugentPay.InitDemoInstance();
    QRPaymentResponse qrPayment = await lugentPay.CreateTrueMoneyTransaction(
        "ค่าอาหาร",
        "่ค่าบริการ",
        "https://dedeposblosstorage.blob.core.windows.net/dedeposassets/app_logo.png",
        lugentPay.CreateReferenceWithUnixTime("SMLINV"),
        "SMLSOFT",
        Decimal.parse(widget.amount.toString()),
        "");
    return qrPayment;
  }

  Future<QRPaymentResponse> qrLugentLinePay() async {
    // Prompay ลูเจ้นท์ ไทย
    LugentPay lugentPay = LugentPay.InitDemoInstance();
    QRPaymentResponse qrPayment = await lugentPay.CreateLinePayTransaction(
        lugentPay.CreateReferenceWithUnixTime("SMLINV"),
        "SMLSOFT",
        Decimal.parse(widget.amount.toString()),
        "");
    return qrPayment;
  }

  @override
  void initState() {
    super.initState();
    switch (widget.provider.wallettype) {
      case 101:
        // Prompay ทั่วไป
        qrCodePayDataString = PromptPay.generateQRData(promptPayDataWithAmount,
            amount: widget.amount.toDouble());
        break;
      case 201:
        // Prompay ลูเจ้นท์ ไทย
        WidgetsBinding.instance.addPostFrameCallback((_) {
          qrLugentPromptPay().then((qrPayment) {
            setState(() {
              qrCodePayDataString = qrPayment.qrCode;
              if (qrPayment.isSuccess()) {
                // transactionId = qrPayment.transactionId;
                qrCodePayDataString = qrPayment.qrCode;
              }
            });
          });
        });
        break;
      case 202:
        // True Money ลูเจ้นท์ ไทย
        WidgetsBinding.instance.addPostFrameCallback((_) {
          qrLugentTrueMoney().then((qrPayment) {
            setState(() {
              qrCodePayDataString = qrPayment.qrCode;
              if (qrPayment.isSuccess()) {
                // transactionId = qrPayment.transactionId;
                qrCodePayDataString = qrPayment.qrCode;
              }
            });
          });
        });
        break;
      case 203:
        // Line Pay ลูเจ้นท์ ไทย
        WidgetsBinding.instance.addPostFrameCallback((_) {
          qrLugentLinePay().then((qrPayment) {
            setState(() {
              qrCodePayDataString = qrPayment.qrCode;
              if (qrPayment.isSuccess()) {
                // transactionId = qrPayment.transactionId;
                qrCodePayDataString = qrPayment.qrCode;
              }
            });
          });
        });
        break;
      case 204:
        // AliPay ลูเจ้นท์ ไทย
        WidgetsBinding.instance.addPostFrameCallback((_) {
          qrLugentAliPay().then((qrPayment) {
            setState(() {
              qrCodePayDataString = qrPayment.qrCode;
              if (qrPayment.isSuccess()) {
                // transactionId = qrPayment.transactionId;
                qrCodePayDataString = qrPayment.qrCode;
              }
            });
          });
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
          height: 100,
          child: Image.asset(
            ("assets/images/qrpay/" + widget.provider.paymentcode + ".png")
                .toLowerCase(),
          )),
      Text(widget.provider.names[0].name,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
      if (qrCodePayDataString.isNotEmpty)
        SizedBox(
            width: 150,
            height: 150,
            child:
                QrImage(data: qrCodePayDataString, version: QrVersions.auto)),
      const SizedBox(height: 8),
      SizedBox(
          width: 150,
          height: 150,
          child: CountDownProgressIndicator(
            controller: countDownController,
            valueColor: Colors.red,
            backgroundColor: Colors.blue,
            initialPosition: 0,
            duration: 5 * 60,
            text: global.language('เหลือเวลาทำรายการ'),
            onComplete: () {
              Navigator.pop(context, false);
            },
            timeFormatter: (seconds) {
              return Duration(seconds: seconds)
                  .toString()
                  .split('.')[0]
                  .padLeft(8, '0');
            },
          )),
      const SizedBox(height: 8),
      SizedBox(
          width: double.infinity,
          child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                global.language('จำนวนเงิน') +
                    ' : ' +
                    global.moneyFormat.format(widget.amount) +
                    ' ' +
                    global.language('money_symbol'),
                style: TextStyle(fontWeight: FontWeight.bold),
              ))),
      SizedBox(height: 8),
      Container(
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text('นาย จตุรพรชัย รัตนปัญญา'),
          )),
      SizedBox(height: 8),
      Container(
          width: double.infinity,
          child: Row(children: [
            Expanded(
              flex: 1,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cancel),
                onPressed: () {
                  Navigator.pop(context, false);
                },
                label: Text(
                  global.language("cancel"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                label: Text(
                  global.language("save"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ]))
    ]);
  }
}
