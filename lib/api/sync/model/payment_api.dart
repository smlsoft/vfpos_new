import 'package:dedepos/api/sync/model/credit_card_payment.dart';
import 'package:dedepos/model/json/transfer_payment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_api.g.dart';

@JsonSerializable()
class PaymentApi {
  double cash;
  double creditcard;
  double transfer;
  List<CreditCardPayment> creditcarddetails = <CreditCardPayment>[];
  List<TransferPayment> transferdetails = <TransferPayment>[];
  PaymentApi({
    required this.cash,
    required this.creditcard,
    required this.creditcarddetails,
    required this.transfer,
    required this.transferdetails,
  });

  factory PaymentApi.fromJson(Map<String, dynamic> json) =>
      _$PaymentApiFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentApiToJson(this);
}
