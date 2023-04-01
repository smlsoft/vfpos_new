import 'package:json_annotation/json_annotation.dart';

part 'credit_card_payment_model.g.dart';

@JsonSerializable()
class CreditCardPaymentModel {
  String cardnumber;
  late String cardtype;
  late String approvedcode;
  late String remark;
  double amount;

  CreditCardPaymentModel({
    required this.cardnumber,
    required this.amount,
    this.cardtype = "",
    this.approvedcode = "",
    this.remark = "",
  });

  factory CreditCardPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$CreditCardPaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreditCardPaymentModelToJson(this);
}
