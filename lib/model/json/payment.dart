import 'package:dedepos/api/sync/model/credit_card_payment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  double cash;
  double creditcard;
  double transfer;
  List<String> creditcarddetails = <String>[];
  List<String> transferdetails = <String>[];
  Payment({
    required this.cash,
    required this.creditcard,
    required this.creditcarddetails,
    required this.transfer,
    required this.transferdetails,
  });

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
