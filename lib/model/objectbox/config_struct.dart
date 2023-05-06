// ignore_for_file: non_constant_identifier_names

import 'package:objectbox/objectbox.dart';

@Entity()
class ConfigObjectBoxStruct {
  int id = 0;
  String device_id;
  String last_doc_number;

  ConfigObjectBoxStruct({
    required this.device_id,
    required this.last_doc_number,
  });
}
