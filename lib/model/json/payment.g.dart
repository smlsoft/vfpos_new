// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      cash: (json['cash'] as num).toDouble(),
      creditcard: (json['creditcard'] as num).toDouble(),
      creditcarddetails: (json['creditcarddetails'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      transfer: (json['transfer'] as num).toDouble(),
      transferdetails: (json['transferdetails'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'cash': instance.cash,
      'creditcard': instance.creditcard,
      'transfer': instance.transfer,
      'creditcarddetails': instance.creditcarddetails,
      'transferdetails': instance.transferdetails,
    };
