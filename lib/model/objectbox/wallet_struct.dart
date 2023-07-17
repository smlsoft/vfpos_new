// ignore_for_file: non_constant_identifier_names

import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_struct.g.dart';

@JsonSerializable()
@Entity()
class WalletObjectBoxStruct {
  int id = 0;
  @Unique()
  String guid_fixed;
  String bankcode;
  String bookbankname;
  String countrycode;
  double feerate;
  String names;
  String paymentcode;
  String paymentlogo;
  int paymenttype;
  int wallettype;

  WalletObjectBoxStruct({
    required this.guid_fixed,
    required this.bankcode,
    required this.bookbankname,
    required this.countrycode,
    required this.feerate,
    required this.names,
    required this.paymentcode,
    required this.paymentlogo,
    required this.paymenttype,
    required this.wallettype,
  });

  factory WalletObjectBoxStruct.fromJson(Map<String, dynamic> json) =>
      _$WalletObjectBoxStructFromJson(json);
  Map<String, dynamic> toJson() => _$WalletObjectBoxStructToJson(this);
}
