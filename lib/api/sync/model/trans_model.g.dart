// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trans_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      cashiercode: json['cashiercode'] as String,
      custcode: json['custcode'] as String,
      custnames: (json['custnames'] as List<dynamic>)
          .map((e) => TransNameInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String,
      details: (json['details'] as List<dynamic>)
          .map((e) => TransDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      discountword: json['discountword'] as String,
      docdatetime: json['docdatetime'] as String,
      docno: json['docno'] as String,
      docrefdate: json['docrefdate'] as String?,
      docrefno: json['docrefno'] as String,
      docreftype: json['docreftype'] as int,
      doctype: json['doctype'] as int,
      guidref: json['guidref'] as String,
      inquirytype: json['inquirytype'] as int,
      iscancel: json['iscancel'] as bool,
      ismanualamount: json['ismanualamount'] as bool,
      ispos: json['ispos'] as bool,
      membercode: json['membercode'] as String,
      salecode: json['salecode'] as String,
      salename: json['salename'] as String,
      status: json['status'] as int,
      taxdocdate: json['taxdocdate'] as String,
      taxdocno: json['taxdocno'] as String,
      totalaftervat: (json['totalaftervat'] as num).toDouble(),
      totalamount: (json['totalamount'] as num).toDouble(),
      totalbeforevat: (json['totalbeforevat'] as num).toDouble(),
      totalcost: (json['totalcost'] as num).toDouble(),
      totaldiscount: (json['totaldiscount'] as num).toDouble(),
      totalexceptvat: (json['totalexceptvat'] as num).toDouble(),
      totalvalue: (json['totalvalue'] as num).toDouble(),
      totalvatvalue: (json['totalvatvalue'] as num).toDouble(),
      transflag: json['transflag'] as int,
      vatrate: (json['vatrate'] as num).toDouble(),
      vattype: json['vattype'] as int,
      paymentdetail: TransPaymentDetailModel.fromJson(
          json['paymentdetail'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'cashiercode': instance.cashiercode,
      'custcode': instance.custcode,
      'custnames': instance.custnames.map((e) => e.toJson()).toList(),
      'description': instance.description,
      'details': instance.details.map((e) => e.toJson()).toList(),
      'discountword': instance.discountword,
      'docdatetime': instance.docdatetime,
      'docno': instance.docno,
      'docrefdate': instance.docrefdate,
      'docrefno': instance.docrefno,
      'docreftype': instance.docreftype,
      'doctype': instance.doctype,
      'guidref': instance.guidref,
      'inquirytype': instance.inquirytype,
      'iscancel': instance.iscancel,
      'ismanualamount': instance.ismanualamount,
      'ispos': instance.ispos,
      'membercode': instance.membercode,
      'salecode': instance.salecode,
      'salename': instance.salename,
      'status': instance.status,
      'taxdocdate': instance.taxdocdate,
      'taxdocno': instance.taxdocno,
      'totalaftervat': instance.totalaftervat,
      'totalamount': instance.totalamount,
      'totalbeforevat': instance.totalbeforevat,
      'totalcost': instance.totalcost,
      'totaldiscount': instance.totaldiscount,
      'totalexceptvat': instance.totalexceptvat,
      'totalvalue': instance.totalvalue,
      'totalvatvalue': instance.totalvatvalue,
      'transflag': instance.transflag,
      'vatrate': instance.vatrate,
      'vattype': instance.vattype,
      'paymentdetail': instance.paymentdetail.toJson(),
    };

TransNameInfoModel _$TransNameInfoModelFromJson(Map<String, dynamic> json) =>
    TransNameInfoModel(
      code: json['code'] as String,
      isauto: json['isauto'] as bool,
      isdelete: json['isdelete'] as bool,
      name: json['name'] as String,
    );

Map<String, dynamic> _$TransNameInfoModelToJson(TransNameInfoModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'isauto': instance.isauto,
      'isdelete': instance.isdelete,
      'name': instance.name,
    };

TransDetailModel _$TransDetailModelFromJson(Map<String, dynamic> json) =>
    TransDetailModel(
      averagecost: (json['averagecost'] as num).toDouble(),
      barcode: json['barcode'] as String,
      calcflag: json['calcflag'] as int,
      discount: json['discount'] as String,
      discountamount: (json['discountamount'] as num).toDouble(),
      dividevalue: (json['dividevalue'] as num).toDouble(),
      docdatetime: json['docdatetime'] as String,
      docref: json['docref'] as String,
      docrefdatetime: json['docrefdatetime'] as String?,
      inquirytype: json['inquirytype'] as int,
      ispos: json['ispos'] as int,
      itemcode: json['itemcode'] as String,
      itemguid: json['itemguid'] as String,
      itemnames: (json['itemnames'] as List<dynamic>)
          .map((e) => TransNameInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemtype: json['itemtype'] as int,
      laststatus: json['laststatus'] as int,
      linenumber: json['linenumber'] as int,
      locationcode: json['locationcode'] as String,
      locationnames: (json['locationnames'] as List<dynamic>)
          .map((e) => TransNameInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      multiunit: json['multiunit'] as bool,
      price: (json['price'] as num).toDouble(),
      priceexcludevat: (json['priceexcludevat'] as num).toDouble(),
      qty: (json['qty'] as num).toDouble(),
      remark: json['remark'] as String,
      shelfcode: json['shelfcode'] as String,
      standvalue: (json['standvalue'] as num).toDouble(),
      sumamount: (json['sumamount'] as num).toDouble(),
      sumamountexcludevat: (json['sumamountexcludevat'] as num).toDouble(),
      sumofcost: (json['sumofcost'] as num).toDouble(),
      taxtype: json['taxtype'] as int,
      tolocationcode: json['tolocationcode'] as String,
      tolocationnames: (json['tolocationnames'] as List<dynamic>)
          .map((e) => TransNameInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalqty: (json['totalqty'] as num).toDouble(),
      totalvaluevat: (json['totalvaluevat'] as num).toDouble(),
      towhcode: json['towhcode'] as String,
      towhnames: (json['towhnames'] as List<dynamic>)
          .map((e) => TransNameInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      unitcode: json['unitcode'] as String,
      unitnames: (json['unitnames'] as List<dynamic>)
          .map((e) => TransNameInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      vatcal: json['vatcal'] as int,
      vattype: json['vattype'] as int,
      whcode: json['whcode'] as String,
      whnames: (json['whnames'] as List<dynamic>)
          .map((e) => TransNameInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TransDetailModelToJson(TransDetailModel instance) =>
    <String, dynamic>{
      'averagecost': instance.averagecost,
      'barcode': instance.barcode,
      'calcflag': instance.calcflag,
      'discount': instance.discount,
      'discountamount': instance.discountamount,
      'dividevalue': instance.dividevalue,
      'docdatetime': instance.docdatetime,
      'docref': instance.docref,
      'docrefdatetime': instance.docrefdatetime,
      'inquirytype': instance.inquirytype,
      'ispos': instance.ispos,
      'itemcode': instance.itemcode,
      'itemguid': instance.itemguid,
      'itemnames': instance.itemnames.map((e) => e.toJson()).toList(),
      'itemtype': instance.itemtype,
      'laststatus': instance.laststatus,
      'linenumber': instance.linenumber,
      'locationcode': instance.locationcode,
      'locationnames': instance.locationnames.map((e) => e.toJson()).toList(),
      'multiunit': instance.multiunit,
      'price': instance.price,
      'priceexcludevat': instance.priceexcludevat,
      'qty': instance.qty,
      'remark': instance.remark,
      'shelfcode': instance.shelfcode,
      'standvalue': instance.standvalue,
      'sumamount': instance.sumamount,
      'sumamountexcludevat': instance.sumamountexcludevat,
      'sumofcost': instance.sumofcost,
      'taxtype': instance.taxtype,
      'tolocationcode': instance.tolocationcode,
      'tolocationnames':
          instance.tolocationnames.map((e) => e.toJson()).toList(),
      'totalqty': instance.totalqty,
      'totalvaluevat': instance.totalvaluevat,
      'towhcode': instance.towhcode,
      'towhnames': instance.towhnames.map((e) => e.toJson()).toList(),
      'unitcode': instance.unitcode,
      'unitnames': instance.unitnames.map((e) => e.toJson()).toList(),
      'vatcal': instance.vatcal,
      'vattype': instance.vattype,
      'whcode': instance.whcode,
      'whnames': instance.whnames.map((e) => e.toJson()).toList(),
    };

PaymentTransferModel _$PaymentTransferModelFromJson(
        Map<String, dynamic> json) =>
    PaymentTransferModel(
      accountNumber: json['accountNumber'] as String,
      amount: json['amount'] as int,
      bankCode: json['bankCode'] as String,
      bankNames: (json['bankNames'] as List<dynamic>)
          .map((e) => TransNameInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      docDateTime: json['docDateTime'] as String,
    );

Map<String, dynamic> _$PaymentTransferModelToJson(
        PaymentTransferModel instance) =>
    <String, dynamic>{
      'accountNumber': instance.accountNumber,
      'amount': instance.amount,
      'bankCode': instance.bankCode,
      'bankNames': instance.bankNames.map((e) => e.toJson()).toList(),
      'docDateTime': instance.docDateTime,
    };

TransLocationInfoModel _$TransLocationInfoModelFromJson(
        Map<String, dynamic> json) =>
    TransLocationInfoModel(
      code: json['code'] as String,
      isauto: json['isauto'] as bool,
      isdelete: json['isdelete'] as bool,
      name: json['name'] as String,
    );

Map<String, dynamic> _$TransLocationInfoModelToJson(
        TransLocationInfoModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'isauto': instance.isauto,
      'isdelete': instance.isdelete,
      'name': instance.name,
    };

TransPaymentDetailModel _$TransPaymentDetailModelFromJson(
        Map<String, dynamic> json) =>
    TransPaymentDetailModel(
      cashamount: (json['cashamount'] as num).toDouble(),
      cashamounttext: json['cashamounttext'] as String,
      paymentcreditcards: (json['paymentcreditcards'] as List<dynamic>)
          .map((e) =>
              TransPaymentCreditCardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymenttransfers: (json['paymenttransfers'] as List<dynamic>)
          .map((e) =>
              TransPaymentTransferModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TransPaymentDetailModelToJson(
        TransPaymentDetailModel instance) =>
    <String, dynamic>{
      'cashamount': instance.cashamount,
      'cashamounttext': instance.cashamounttext,
      'paymentcreditcards':
          instance.paymentcreditcards.map((e) => e.toJson()).toList(),
      'paymenttransfers':
          instance.paymenttransfers.map((e) => e.toJson()).toList(),
    };

TransPaymentCreditCardModel _$TransPaymentCreditCardModelFromJson(
        Map<String, dynamic> json) =>
    TransPaymentCreditCardModel(
      amount: (json['amount'] as num).toDouble(),
      cardnumber: json['cardnumber'] as String,
      chargevalue: (json['chargevalue'] as num).toDouble(),
      chargeword: json['chargeword'] as String,
      docdatetime: json['docdatetime'] as String,
      totalnetworth: (json['totalnetworth'] as num).toDouble(),
    );

Map<String, dynamic> _$TransPaymentCreditCardModelToJson(
        TransPaymentCreditCardModel instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'cardnumber': instance.cardnumber,
      'chargevalue': instance.chargevalue,
      'chargeword': instance.chargeword,
      'docdatetime': instance.docdatetime,
      'totalnetworth': instance.totalnetworth,
    };

TransPaymentTransferModel _$TransPaymentTransferModelFromJson(
        Map<String, dynamic> json) =>
    TransPaymentTransferModel(
      accountnumber: json['accountnumber'] as String,
      amount: (json['amount'] as num).toDouble(),
      bankcode: json['bankcode'] as String,
      banknames: (json['banknames'] as List<dynamic>)
          .map((e) => TransNameInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      docdatetime: json['docdatetime'] as String,
    );

Map<String, dynamic> _$TransPaymentTransferModelToJson(
        TransPaymentTransferModel instance) =>
    <String, dynamic>{
      'accountnumber': instance.accountnumber,
      'amount': instance.amount,
      'bankcode': instance.bankcode,
      'banknames': instance.banknames.map((e) => e.toJson()).toList(),
      'docdatetime': instance.docdatetime,
    };
