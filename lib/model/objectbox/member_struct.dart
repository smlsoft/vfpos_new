import 'package:objectbox/objectbox.dart';

@Entity()
class MemberObjectBoxStruct {
  int id = 0;
  @Unique()
  String guidfixed;
  String address;
  String branchcode;
  int branchtype;
  int contacttype;
  String name;
  int personaltype;
  String surname;
  String taxid;
  String telephone;
  String zipcode;

  MemberObjectBoxStruct({
    this.guidfixed = "",
    this.address = "",
    this.branchcode = "",
    required this.branchtype,
    required this.contacttype,
    required this.name,
    required this.personaltype,
    this.surname = "",
    this.taxid = "",
    this.telephone = "",
    this.zipcode = "",
  });
}
