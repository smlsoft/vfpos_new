// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardPaymentModel _$CreditCardPaymentModelFromJson(
        Map<String, dynamic> json) =>
    CreditCardPaymentModel(
      cardnumber: json['cardnumber'] as String,
      amount: (json['amount'] as num).toDouble(),
      cardtype: json['cardtype'] as String? ?? "",
      approvedcode: json['approvedcode'] as String? ?? "",
      remark: json['remark'] as String? ?? "",
    );

Map<String, dynamic> _$CreditCardPaymentModelToJson(
        CreditCardPaymentModel instance) =>
    <String, dynamic>{
      'cardnumber': instance.cardnumber,
      'cardtype': instance.cardtype,
      'approvedcode': instance.approvedcode,
      'remark': instance.remark,
      'amount': instance.amount,
    };
