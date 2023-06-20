// ignore_for_file: non_constant_identifier_names

import 'package:objectbox/objectbox.dart';

@Entity()
class TableObjectBoxStruct {
  int id = 0;
  @Unique()
  String guidfixed;
  String number;
  String name1;
  String zone;

  TableObjectBoxStruct({
    required this.guidfixed,
    required this.number,
    required this.name1,
    required this.zone,
  });
}
