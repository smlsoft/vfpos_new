// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentApi _$PaymentApiFromJson(Map<String, dynamic> json) => PaymentApi(
      cash: (json['cash'] as num).toDouble(),
      creditcard: (json['creditcard'] as num).toDouble(),
      creditcarddetails: (json['creditcarddetails'] as List<dynamic>)
          .map((e) => CreditCardPayment.fromJson(e as Map<String, dynamic>))
          .toList(),
      transfer: (json['transfer'] as num).toDouble(),
      transferdetails: (json['transferdetails'] as List<dynamic>)
          .map((e) => TransferPayment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PaymentApiToJson(PaymentApi instance) =>
    <String, dynamic>{
      'cash': instance.cash,
      'creditcard': instance.creditcard,
      'transfer': instance.transfer,
      'creditcarddetails': instance.creditcarddetails,
      'transferdetails': instance.transferdetails,
    };
