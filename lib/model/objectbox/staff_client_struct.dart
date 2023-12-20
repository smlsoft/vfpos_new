// ignore_for_file: non_constant_identifier_names

import 'package:objectbox/objectbox.dart';

@Entity()
class StaffClientObjectBoxStruct {
  int id = 0;
  @Unique()
  String guid;
  String name;
  String device_guid;
  String device_ip;

  StaffClientObjectBoxStruct({
    this.guid = "",
    this.name = "",
    this.device_guid = "",
    this.device_ip = "",
  });
}
