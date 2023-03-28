import 'package:objectbox/objectbox.dart';

@Entity()
class EmployeeObjectBoxStruct {
  int id = 0;
  @Unique()
  String guidfixed;
  String code;
  String username;
  String profilepicture;
  String name;
  //String roles;

  EmployeeObjectBoxStruct({
    required this.guidfixed,
    required this.username,
    required this.code,
    //required this.roles,
    required this.profilepicture,
    required this.name,
  });
}
