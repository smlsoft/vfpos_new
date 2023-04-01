import 'package:dedepos/api/sync/model/credit_card_payment_model.dart';
import 'package:dedepos/model/json/transfer_payment_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_api_model.g.dart';

@JsonSerializable()
class PaymentApiModel {
  double cash;
  double creditcard;
  double transfer;
  List<CreditCardPaymentModel> creditcarddetails = <CreditCardPaymentModel>[];
  List<TransferPaymentModel> transferdetails = <TransferPaymentModel>[];
  PaymentApiModel({
    required this.cash,
    required this.creditcard,
    required this.creditcarddetails,
    required this.transfer,
    required this.transferdetails,
  });

  factory PaymentApiModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentApiModelToJson(this);
}
