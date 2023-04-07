import 'package:json_annotation/json_annotation.dart';
part 'sync_employee_model.g.dart';

@JsonSerializable()
class SyncEmployeeModel {
  String guidfixed;
  String code;
  String email;
  bool isenabled;
  String name;
  String profilepicture;

  SyncEmployeeModel({
    required this.guidfixed,
    required this.code,
    required this.profilepicture,
    required this.name,
    required this.email,
    required this.isenabled,
  });

  factory SyncEmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$SyncEmployeeModelFromJson(json);
  Map<String, dynamic> toJson() => _$SyncEmployeeModelToJson(this);
}
