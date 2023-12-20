import 'package:decimal/decimal.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart';
import 'package:flutter/material.dart';
import 'package:lugentpayment/lugentpay.dart';
import 'package:lugentpayment/qrpayment_response.dart';
import 'package:promptpay/promptpay.dart';
import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PayQrScreen extends StatefulWidget {
  final ProfileQrPaymentModel provider;
  final double amount;
  final BuildContext context;

  const PayQrScreen({Key? key, required this.provider, required this.amount, required this.context}) : super(key: key);

  @override
  State<PayQrScreen> createState() => _PayQrScreenState();
}

class _PayQrScreenState extends State<PayQrScreen> with TickerProviderStateMixin {
  final countDownController = CountDownController();
  String qrCodePayDataString = "";

  Future<QRPaymentResponse> qrLugentPromptPay() async {
    // Promptpay ลูเจ้นท์ ไทย
    LugentPay lugentPay = LugentPay.InitDemoInstance();
    QRPaymentResponse qrPayment =
        await lugentPay.CreateThaiQRPaymentTransaction(lugentPay.CreateReferenceWithUnixTime("SMLINV"), "SMLSOFT", Decimal.parse(widget.amount.toString()), "");
    return qrPayment;
  }

  Future<QRPaymentResponse> qrLugentAliPay() async {
    // Promptpay ลูเจ้นท์ ไทย
    LugentPay lugentPay = LugentPay.InitDemoInstance();
    QRPaymentResponse qrPayment = await lugentPay.CreateAliPayTransaction(lugentPay.CreateReferenceWithUnixTime("SMLINV"), "SMLSOFT", Decimal.parse(widget.amount.toString()), "");
    return qrPayment;
  }

  Future<QRPaymentResponse> qrLugentTrueMoney() async {
    // Promptpay ลูเจ้นท์ ไทย
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
    // Promptpay ลูเจ้นท์ ไทย
    LugentPay lugentPay = LugentPay.InitDemoInstance();
    QRPaymentResponse qrPayment = await lugentPay.CreateLinePayTransaction(lugentPay.CreateReferenceWithUnixTime("SMLINV"), "SMLSOFT", Decimal.parse(widget.amount.toString()), "");
    return qrPayment;
  }

  @override
  void initState() {
    super.initState();
    switch (widget.provider.qrtype) {
      case 100:
        // Promptpay ทั่วไป
        qrCodePayDataString = PromptPay.generateQRData(widget.provider.qrcode, amount: widget.amount.toDouble());
        break;
      case 110:
        // Promptpay ลูเจ้นท์ ไทย
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
      case 111:
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
      case 112:
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
      case 113:
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.provider.logo.isNotEmpty)
            SizedBox(
                height: 100,
                child: Image.network(
                  widget.provider.logo,
                )),
          if (widget.provider.logo.isNotEmpty) Spacer(),
          SizedBox(
              width: 100,
              height: 100,
              child: CountDownProgressIndicator(
                controller: countDownController,
                valueColor: Colors.red,
                backgroundColor: Colors.blue,
                initialPosition: 0,
                duration: 5 * 60,
                text: global.language('time_remaining_to_complete_the_transaction'),
                onComplete: () {
                  Navigator.pop(context, false);
                },
                timeFormatter: (seconds) {
                  return Duration(seconds: seconds).toString().split('.')[0].substring(2);
                },
              )),
        ],
      ),
      Text(global.getNameFromLanguage(widget.provider.qrnames, global.userScreenLanguage), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
      if (qrCodePayDataString.isNotEmpty) SizedBox(width: 100, height: 100, child: QrImageView(data: qrCodePayDataString, version: QrVersions.auto)),
      SizedBox(
          width: double.infinity,
          child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                '${global.language('money_amount')} : ${global.moneyFormat.format(widget.amount)} ${global.language('money_symbol')}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.grey,
                    offset: Offset(1.0, 1.0),
                  ),
                ]),
              ))),
      const SizedBox(height: 8),
      (widget.provider.qrcode.isNotEmpty)
          ? SizedBox(
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(widget.provider.qrcode, style: TextStyle(fontWeight: FontWeight.bold)),
              ))
          : Container(),
      const SizedBox(height: 8),
      SizedBox(
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                label: Text(
                  global.language("save"),
                  style: const TextStyle(
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
