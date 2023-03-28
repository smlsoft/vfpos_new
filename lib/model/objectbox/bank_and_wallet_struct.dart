import 'package:objectbox/objectbox.dart';

@Entity()
class BankAndWalletObjectBoxStruct {
  int id = 0;
  @Unique() 
  String paymentcode;
  String countrycode;
  String name1;
  String name2;
  String name3;
  String name4;
  String name5;
  String paymentlogo;
  int paymenttype;
  double feeRate;
  int wallettype;

  BankAndWalletObjectBoxStruct({
    this.paymentcode = "",
    this.countrycode = "",
    this.name1 = "",
    this.name2 = "",
    this.name3 = "",
    this.name4 = "",
    this.name5 = "",
    this.paymentlogo = "",
    this.paymenttype = 0,
    this.wallettype = 0,
    this.feeRate = 0.0,
  });
}
