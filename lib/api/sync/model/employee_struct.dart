import 'package:json_annotation/json_annotation.dart';
part 'employee_struct.g.dart';

@JsonSerializable()
class EmployeeStruct {
  late String code;
  late String guidfixed;
  late String username;
  late String name;
  late String profilepicture;
  // late List<String> roles;

  EmployeeStruct({
    required this.code,
    required this.guidfixed,
    required this.username,
    required this.profilepicture,
    // required this.roles,
    required this.name,
  });

  factory EmployeeStruct.fromJson(Map<String, dynamic> json) =>
      _$EmployeeStructFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeStructToJson(this);
}
