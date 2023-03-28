import 'package:objectbox/objectbox.dart';

@Entity()
class ConfigObjectBoxStruct {
  int id = 0;
  String device_code;
  String last_doc_number;

  ConfigObjectBoxStruct({
    required this.device_code,
    required this.last_doc_number,
  });
}
