import 'package:json_annotation/json_annotation.dart';

part 'transfer_payment.g.dart';

@JsonSerializable()
class TransferPayment {
  String bankcode;
  double amount;

  TransferPayment({
    required this.bankcode,
    required this.amount,
  });

  factory TransferPayment.fromJson(Map<String, dynamic> json) =>
      _$TransferPaymentFromJson(json);

  Map<String, dynamic> toJson() => _$TransferPaymentToJson(this);
}
