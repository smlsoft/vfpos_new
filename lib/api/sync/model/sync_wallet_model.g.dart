// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncWalletModel _$SyncWalletModelFromJson(Map<String, dynamic> json) =>
    SyncWalletModel(
      guidfixed: json['guidfixed'] as String,
      bankcode: json['bankcode'] as String,
      bookbankname: json['bookbankname'] as String,
      countrycode: json['countrycode'] as String,
      feerate: (json['feerate'] as num).toDouble(),
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentcode: json['paymentcode'] as String,
      paymentlogo: json['paymentlogo'] as String,
      paymenttype: json['paymenttype'] as int,
      wallettype: json['wallettype'] as int,
    );

Map<String, dynamic> _$SyncWalletModelToJson(SyncWalletModel instance) =>
    <String, dynamic>{
      'guidfixed': instance.guidfixed,
      'bankcode': instance.bankcode,
      'bookbankname': instance.bookbankname,
      'countrycode': instance.countrycode,
      'feerate': instance.feerate,
      'names': instance.names,
      'paymentcode': instance.paymentcode,
      'paymentlogo': instance.paymentlogo,
      'paymenttype': instance.paymenttype,
      'wallettype': instance.wallettype,
    };
