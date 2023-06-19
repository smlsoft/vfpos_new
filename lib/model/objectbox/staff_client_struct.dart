import 'package:objectbox/objectbox.dart';

@Entity()
class StaffClientObjectBoxStruct {
  int id = 0;
  @Unique()
  String guid;
  String name;
  String deviceGuid;
  String deviceIp;

  StaffClientObjectBoxStruct({
    this.guid = "",
    this.name = "",
    this.deviceGuid = "",
    this.deviceIp = "",
  });
}
