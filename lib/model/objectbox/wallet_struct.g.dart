// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletObjectBoxStruct _$WalletObjectBoxStructFromJson(
        Map<String, dynamic> json) =>
    WalletObjectBoxStruct(
      code: json['code'] as String,
      guid_fixed: json['guid_fixed'] as String,
      bookbankcode: json['bookbankcode'] as String,
      bookbankname: json['bookbankname'] as String,
      countrycode: json['countrycode'] as String,
      feerate: (json['feerate'] as num).toDouble(),
      names: json['names'] as String,
      paymentcode: json['paymentcode'] as String,
      paymentlogo: json['paymentlogo'] as String,
      paymenttype: json['paymenttype'] as int,
      wallettype: json['wallettype'] as int,
    )..id = json['id'] as int;

Map<String, dynamic> _$WalletObjectBoxStructToJson(
        WalletObjectBoxStruct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'guid_fixed': instance.guid_fixed,
      'bookbankcode': instance.bookbankcode,
      'bookbankname': instance.bookbankname,
      'countrycode': instance.countrycode,
      'feerate': instance.feerate,
      'names': instance.names,
      'paymentcode': instance.paymentcode,
      'paymentlogo': instance.paymentlogo,
      'paymenttype': instance.paymenttype,
      'wallettype': instance.wallettype,
    };
