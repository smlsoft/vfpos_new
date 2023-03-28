// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferPayment _$TransferPaymentFromJson(Map<String, dynamic> json) =>
    TransferPayment(
      bankcode: json['bankcode'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$TransferPaymentToJson(TransferPayment instance) =>
    <String, dynamic>{
      'bankcode': instance.bankcode,
      'amount': instance.amount,
    };
