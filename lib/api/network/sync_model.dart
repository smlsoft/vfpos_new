import 'package:json_annotation/json_annotation.dart';

part 'sync_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SyncCustomerDisplayModel {
  String code;
  String phone;
  String name;

  SyncCustomerDisplayModel(
      {required this.code, required this.phone, required this.name});

  factory SyncCustomerDisplayModel.fromJson(Map<String, dynamic> json) =>
      _$SyncCustomerDisplayModelFromJson(json);

  Map<String, dynamic> toJson() => _$SyncCustomerDisplayModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SyncDeviceModel {
  String device;
  String ip;
  bool connected;
  bool isCashierTerminal;
  bool isClient;
  int holdNumberActive;
  int docModeActive;
  bool processSuccess;

  SyncDeviceModel(
      {required this.device,
      required this.ip,
      required this.connected,
      required this.isCashierTerminal,
      required this.isClient,
      required this.holdNumberActive,
      required this.docModeActive,
      this.processSuccess = true});

  factory SyncDeviceModel.fromJson(Map<String, dynamic> json) =>
      _$SyncDeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SyncDeviceModelToJson(this);
}
