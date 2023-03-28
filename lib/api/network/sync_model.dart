import 'package:json_annotation/json_annotation.dart';

part 'sync_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SyncCustomerModel {
  String code;
  String phone;
  String name;

  SyncCustomerModel(
      {required this.code, required this.phone, required this.name});

  factory SyncCustomerModel.fromJson(Map<String, dynamic> json) =>
      _$SyncCustomerModelFromJson(json);

  Map<String, dynamic> toJson() => _$SyncCustomerModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SyncDeviceModel {
  String device;
  String ip;
  bool connected;

  SyncDeviceModel(
      {required this.device, required this.ip, required this.connected});

  factory SyncDeviceModel.fromJson(Map<String, dynamic> json) =>
      _$SyncDeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SyncDeviceModelToJson(this);
}
