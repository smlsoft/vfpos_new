import 'package:objectbox/objectbox.dart';

@Entity()
class BuffetModeObjectBoxStruct {
  int id = 0;
  @Unique()
  String code;
  List<String> names;
  double adultPrice;
  double childPrice;
  int maxMinute = 0;

  BuffetModeObjectBoxStruct({
    required this.code,
    required this.names,
    required this.adultPrice,
    required this.childPrice,
    required this.maxMinute,
  });
}
