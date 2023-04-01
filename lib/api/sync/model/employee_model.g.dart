// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) =>
    EmployeeModel(
      code: json['code'] as String,
      guidfixed: json['guidfixed'] as String,
      username: json['username'] as String,
      profilepicture: json['profilepicture'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$EmployeeModelToJson(EmployeeModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'guidfixed': instance.guidfixed,
      'username': instance.username,
      'name': instance.name,
      'profilepicture': instance.profilepicture,
    };
