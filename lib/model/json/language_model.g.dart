// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageDataModel _$LanguageDataModelFromJson(Map<String, dynamic> json) =>
    LanguageDataModel(
      code: json['code'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$LanguageDataModelToJson(LanguageDataModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
    };

LanguageSystemModel _$LanguageSystemModelFromJson(Map<String, dynamic> json) =>
    LanguageSystemModel(
      code: json['code'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$LanguageSystemModelToJson(
        LanguageSystemModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'text': instance.text,
    };
