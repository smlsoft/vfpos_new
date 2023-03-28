import 'package:objectbox/objectbox.dart';

@Entity()
class WalletStruct {
  int id = 0;
  @Unique()
  String code;
  String name1;
  String name2;
  String name3;
  String name4;
  String name5;
  String image;

  WalletStruct({
    this.code = "",
    this.name1 = "",
    this.name2 = "",
    this.name3 = "",
    this.name4 = "",
    this.name5 = "",
    this.image = "",
  });
}
