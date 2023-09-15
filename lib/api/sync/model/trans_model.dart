import 'package:json_annotation/json_annotation.dart';
part 'trans_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TransactionModel {
  String cashiercode;
  String custcode;
  List<TransNameInfoModel> custnames;
  String description;
  List<TransDetailModel> details;
  String discountword;
  String docdatetime;
  String docno;
  String? docrefdate;
  String docrefno;
  int docreftype;
  int doctype;
  String guidref;
  int inquirytype;
  bool iscancel;
  bool ismanualamount;
  bool ispos;
  String membercode;
  String salecode;
  String salename;
  int status;
  String taxdocdate;
  String taxdocno;
  double totalaftervat;
  double totalamount;
  double totalbeforevat;
  double totalcost;
  double totaldiscount;
  double totalexceptvat;
  double totalvalue;
  double totalvatvalue;
  int transflag;
  double vatrate;
  int vattype;
  TransPaymentDetailModel paymentdetail;
  String paymentdetailraw;
  TransactionModel({
    required this.cashiercode,
    required this.custcode,
    required this.custnames,
    required this.description,
    required this.details,
    required this.discountword,
    required this.docdatetime,
    required this.docno,
    required this.docrefdate,
    required this.docrefno,
    required this.docreftype,
    required this.doctype,
    required this.guidref,
    required this.inquirytype,
    required this.iscancel,
    required this.ismanualamount,
    required this.ispos,
    required this.membercode,
    required this.salecode,
    required this.salename,
    required this.status,
    required this.taxdocdate,
    required this.taxdocno,
    required this.totalaftervat,
    required this.totalamount,
    required this.totalbeforevat,
    required this.totalcost,
    required this.totaldiscount,
    required this.totalexceptvat,
    required this.totalvalue,
    required this.totalvatvalue,
    required this.transflag,
    required this.vatrate,
    required this.vattype,
    required this.paymentdetail,
    required this.paymentdetailraw,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TransNameInfoModel {
  String code;
  bool isauto;
  bool isdelete;
  String name;

  TransNameInfoModel({
    String? code,
    bool? isauto,
    bool? isdelete,
    String? name,
  })  : code = code ?? "",
        isauto = isauto ?? false,
        isdelete = isdelete ?? false,
        name = name ?? "";

  factory TransNameInfoModel.fromJson(Map<String, dynamic> json) => _$TransNameInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransNameInfoModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TransDetailModel {
  double averagecost;
  String barcode;
  int calcflag;
  String discount;
  double discountamount;
  double dividevalue;
  String docdatetime;
  String docref;
  String? docrefdatetime;
  int inquirytype;
  int ispos;
  String itemcode;
  String itemguid;
  List<TransNameInfoModel> itemnames;
  int itemtype;
  int laststatus;
  int linenumber;
  String locationcode;
  List<TransNameInfoModel> locationnames;
  bool multiunit;
  double price;
  double priceexcludevat;
  double qty;
  String remark;
  String shelfcode;
  double standvalue;
  double sumamount;
  double sumamountexcludevat;
  double sumofcost;
  int taxtype;
  String tolocationcode;
  List<TransNameInfoModel> tolocationnames;
  double totalqty;
  double totalvaluevat;
  String towhcode;
  List<TransNameInfoModel> towhnames;
  String unitcode;
  List<TransNameInfoModel> unitnames;
  int vatcal;
  int vattype;
  String whcode;
  List<TransNameInfoModel> whnames;

  TransDetailModel({
    required this.averagecost,
    required this.barcode,
    required this.calcflag,
    required this.discount,
    required this.discountamount,
    required this.dividevalue,
    required this.docdatetime,
    required this.docref,
    required this.docrefdatetime,
    required this.inquirytype,
    required this.ispos,
    required this.itemcode,
    required this.itemguid,
    required this.itemnames,
    required this.itemtype,
    required this.laststatus,
    required this.linenumber,
    required this.locationcode,
    required this.locationnames,
    required this.multiunit,
    required this.price,
    required this.priceexcludevat,
    required this.qty,
    required this.remark,
    required this.shelfcode,
    required this.standvalue,
    required this.sumamount,
    required this.sumamountexcludevat,
    required this.sumofcost,
    required this.taxtype,
    required this.tolocationcode,
    required this.tolocationnames,
    required this.totalqty,
    required this.totalvaluevat,
    required this.towhcode,
    required this.towhnames,
    required this.unitcode,
    required this.unitnames,
    required this.vatcal,
    required this.vattype,
    required this.whcode,
    required this.whnames,
  });

  factory TransDetailModel.fromJson(Map<String, dynamic> json) => _$TransDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransDetailModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PaymentTransferModel {
  String accountNumber;
  int amount;
  String bankCode;
  List<TransNameInfoModel> bankNames;
  String docDateTime;

  PaymentTransferModel({
    required this.accountNumber,
    required this.amount,
    required this.bankCode,
    required this.bankNames,
    required this.docDateTime,
  });

  factory PaymentTransferModel.fromJson(Map<String, dynamic> json) => _$PaymentTransferModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentTransferModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TransLocationInfoModel {
  String code;
  bool isauto;
  bool isdelete;
  String name;

  TransLocationInfoModel({
    required this.code,
    required this.isauto,
    required this.isdelete,
    required this.name,
  });

  factory TransLocationInfoModel.fromJson(Map<String, dynamic> json) => _$TransLocationInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransLocationInfoModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TransPaymentDetailModel {
  double cashamount;
  String cashamounttext;
  List<TransPaymentCreditCardModel> paymentcreditcards;
  List<TransPaymentTransferModel> paymenttransfers;

  TransPaymentDetailModel({
    required this.cashamount,
    required this.cashamounttext,
    required this.paymentcreditcards,
    required this.paymenttransfers,
  });

  factory TransPaymentDetailModel.fromJson(Map<String, dynamic> json) => _$TransPaymentDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransPaymentDetailModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TransPaymentCreditCardModel {
  double amount;
  String cardnumber;
  double chargevalue;
  String chargeword;
  String docdatetime;
  double totalnetworth;

  TransPaymentCreditCardModel({
    required this.amount,
    required this.cardnumber,
    required this.chargevalue,
    required this.chargeword,
    required this.docdatetime,
    required this.totalnetworth,
  });

  factory TransPaymentCreditCardModel.fromJson(Map<String, dynamic> json) => _$TransPaymentCreditCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransPaymentCreditCardModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TransPaymentTransferModel {
  String accountnumber;
  double amount;
  String bankcode;
  List<TransNameInfoModel> banknames;
  String docdatetime;

  TransPaymentTransferModel({
    required this.accountnumber,
    required this.amount,
    required this.bankcode,
    required this.banknames,
    required this.docdatetime,
  });

  factory TransPaymentTransferModel.fromJson(Map<String, dynamic> json) => _$TransPaymentTransferModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransPaymentTransferModelToJson(this);
}
