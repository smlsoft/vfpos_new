import 'package:objectbox/objectbox.dart';

@Entity()
class EmployeeObjectBoxStruct {
  int id = 0;
  @Unique()
  String guidfixed;
  String code;
  String email;
  bool isenabled;
  String name;
  String profilepicture;

  EmployeeObjectBoxStruct({
    required this.guidfixed,
    required this.code,
    required this.profilepicture,
    required this.name,
    required this.email,
    required this.isenabled,
  });
}
