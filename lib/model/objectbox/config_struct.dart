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
