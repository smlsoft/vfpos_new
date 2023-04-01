// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_and_wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiBankAndWalletModel _$ApiBankAndWalletModelFromJson(
        Map<String, dynamic> json) =>
    ApiBankAndWalletModel(
      paymentcode: json['paymentcode'] as String? ?? "",
      countrycode: json['countrycode'] as String? ?? "",
      name1: json['name1'] as String? ?? "",
      name2: json['name2'] as String? ?? "",
      name3: json['name3'] as String? ?? "",
      name4: json['name4'] as String? ?? "",
      name5: json['name5'] as String? ?? "",
      paymentlogo: json['paymentlogo'] as String? ?? "",
      paymenttype: json['paymenttype'] as int? ?? 0,
      feerate: (json['feerate'] as num?)?.toDouble() ?? 0,
      wallettype: json['wallettype'] as int? ?? 0,
    );

Map<String, dynamic> _$ApiBankAndWalletModelToJson(
        ApiBankAndWalletModel instance) =>
    <String, dynamic>{
      'countrycode': instance.countrycode,
      'paymentcode': instance.paymentcode,
      'name1': instance.name1,
      'name2': instance.name2,
      'name3': instance.name3,
      'name4': instance.name4,
      'name5': instance.name5,
      'paymentlogo': instance.paymentlogo,
      'paymenttype': instance.paymenttype,
      'feerate': instance.feerate,
      'wallettype': instance.wallettype,
    };
