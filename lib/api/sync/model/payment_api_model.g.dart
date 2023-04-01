// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentApiModel _$PaymentApiModelFromJson(Map<String, dynamic> json) =>
    PaymentApiModel(
      cash: (json['cash'] as num).toDouble(),
      creditcard: (json['creditcard'] as num).toDouble(),
      creditcarddetails: (json['creditcarddetails'] as List<dynamic>)
          .map(
              (e) => CreditCardPaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      transfer: (json['transfer'] as num).toDouble(),
      transferdetails: (json['transferdetails'] as List<dynamic>)
          .map((e) => TransferPaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PaymentApiModelToJson(PaymentApiModel instance) =>
    <String, dynamic>{
      'cash': instance.cash,
      'creditcard': instance.creditcard,
      'transfer': instance.transfer,
      'creditcarddetails': instance.creditcarddetails,
      'transferdetails': instance.transferdetails,
    };
