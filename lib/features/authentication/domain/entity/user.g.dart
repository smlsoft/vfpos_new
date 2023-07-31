// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      token: json['token'] as String? ?? '',
      isDev: json['isDev'] as int? ?? 0,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
      'token': instance.token,
      'isDev': instance.isDev,
    };
