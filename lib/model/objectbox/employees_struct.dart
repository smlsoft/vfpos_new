// ignore_for_file: non_constant_identifier_names

import 'package:objectbox/objectbox.dart';

@Entity()
class EmployeeObjectBoxStruct {
  int id = 0;
  @Unique()
  String guidfixed;
  String code;
  String email;
  bool is_enabled;
  String name;
  String profile_picture;

  EmployeeObjectBoxStruct({
    required this.guidfixed,
    required this.code,
    required this.profile_picture,
    required this.name,
    required this.email,
    required this.is_enabled,
  });
}
