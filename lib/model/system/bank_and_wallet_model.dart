import 'package:dedepos/model/json/language_model.dart';

class PaymentProviderModel {
  String providercode;
  String paymentcode;
  String bookbankcode;
  String countrycode;
  List<LanguageModel> names;
  String paymentlogo;
  int paymenttype;
  double feeRate;
  int wallettype;

  PaymentProviderModel({
    required this.providercode,
    required this.paymentcode,
    required this.bookbankcode,
    required this.countrycode,
    required this.paymentlogo,
    required this.paymenttype,
    required this.feeRate,
    required this.wallettype,
    required this.names,
  });
}
