import 'package:json_annotation/json_annotation.dart';

part 'credit_card_payment.g.dart';

@JsonSerializable()
class CreditCardPayment {
  String cardnumber;
  late String cardtype;
  late String approvedcode;
  late String remark;
  double amount;

  CreditCardPayment({
    required this.cardnumber,
    required this.amount,
    this.cardtype = "",
    this.approvedcode = "",
    this.remark = "",
  });

  factory CreditCardPayment.fromJson(Map<String, dynamic> json) =>
      _$CreditCardPaymentFromJson(json);

  Map<String, dynamic> toJson() => _$CreditCardPaymentToJson(this);
}
