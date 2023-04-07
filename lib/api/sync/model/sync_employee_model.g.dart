// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncEmployeeModel _$SyncEmployeeModelFromJson(Map<String, dynamic> json) =>
    SyncEmployeeModel(
      guidfixed: json['guidfixed'] as String,
      code: json['code'] as String,
      profilepicture: json['profilepicture'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      isenabled: json['isenabled'] as bool,
    );

Map<String, dynamic> _$SyncEmployeeModelToJson(SyncEmployeeModel instance) =>
    <String, dynamic>{
      'guidfixed': instance.guidfixed,
      'code': instance.code,
      'email': instance.email,
      'isenabled': instance.isenabled,
      'name': instance.name,
      'profilepicture': instance.profilepicture,
    };
