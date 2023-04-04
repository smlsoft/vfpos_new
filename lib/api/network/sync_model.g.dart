// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncCustomerModel _$SyncCustomerModelFromJson(Map<String, dynamic> json) =>
    SyncCustomerModel(
      code: json['code'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$SyncCustomerModelToJson(SyncCustomerModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'phone': instance.phone,
      'name': instance.name,
    };

SyncDeviceModel _$SyncDeviceModelFromJson(Map<String, dynamic> json) =>
    SyncDeviceModel(
      device: json['device'] as String,
      ip: json['ip'] as String,
      connected: json['connected'] as bool,
      isCashierTerminal: json['isCashierTerminal'] as bool,
      isClient: json['isClient'] as bool,
      holdNumberActive: json['holdNumberActive'] as int,
      processSuccess: json['processSuccess'] as bool? ?? true,
    );

Map<String, dynamic> _$SyncDeviceModelToJson(SyncDeviceModel instance) =>
    <String, dynamic>{
      'device': instance.device,
      'ip': instance.ip,
      'connected': instance.connected,
      'isCashierTerminal': instance.isCashierTerminal,
      'isClient': instance.isClient,
      'holdNumberActive': instance.holdNumberActive,
      'processSuccess': instance.processSuccess,
    };
