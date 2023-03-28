import 'package:decimal/decimal.dart';

class PaymentData {
  PaymentData(this.paymentMethod, this.amount, this.payToAccount);
  final PaymentMethod paymentMethod;
  final Decimal amount;
  String payToAccount;
}

enum PaymentMethod {
  thaiQRCode,
  lugentThaiQRCode,
  lugentTrueMoney,
  lugentLinePay,
  lugentAliPay,
  lugentBCELOnePay
}
