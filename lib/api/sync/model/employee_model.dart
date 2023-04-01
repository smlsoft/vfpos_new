import 'package:json_annotation/json_annotation.dart';
part 'employee_model.g.dart';

@JsonSerializable()
class EmployeeModel {
  late String code;
  late String guidfixed;
  late String username;
  late String name;
  late String profilepicture;
  // late List<String> roles;

  EmployeeModel({
    required this.code,
    required this.guidfixed,
    required this.username,
    required this.profilepicture,
    // required this.roles,
    required this.name,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeModelFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);
}
