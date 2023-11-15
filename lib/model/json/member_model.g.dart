// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberModel _$MemberModelFromJson(Map<String, dynamic> json) => MemberModel(
      code: json['code'] as String,
      names: (json['names'] as List<dynamic>)
          .map((e) => LanguageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      addressforbilling: MemberAddressForBillingModel.fromJson(
          json['addressforbilling'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MemberModelToJson(MemberModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'names': instance.names.map((e) => e.toJson()).toList(),
      'addressforbilling': instance.addressforbilling.toJson(),
    };

MemberAddressForBillingModel _$MemberAddressForBillingModelFromJson(
        Map<String, dynamic> json) =>
    MemberAddressForBillingModel(
      phoneprimary: json['phoneprimary'] as String,
      phonesecondary: json['phonesecondary'] as String,
    );

Map<String, dynamic> _$MemberAddressForBillingModelToJson(
        MemberAddressForBillingModel instance) =>
    <String, dynamic>{
      'phoneprimary': instance.phoneprimary,
      'phonesecondary': instance.phonesecondary,
    };
