// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeStruct _$EmployeeStructFromJson(Map<String, dynamic> json) =>
    EmployeeStruct(
      code: json['code'] as String,
      guidfixed: json['guidfixed'] as String,
      username: json['username'] as String,
      profilepicture: json['profilepicture'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$EmployeeStructToJson(EmployeeStruct instance) =>
    <String, dynamic>{
      'code': instance.code,
      'guidfixed': instance.guidfixed,
      'username': instance.username,
      'name': instance.name,
      'profilepicture': instance.profilepicture,
    };
