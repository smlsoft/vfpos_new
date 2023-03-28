// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_bill_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiBillStruct _$ApiBillStructFromJson(Map<String, dynamic> json) =>
    ApiBillStruct(
      doc_number: json['doc_number'] as String,
      date_time: DateTime.parse(json['date_time'] as String),
      customer_code: json['customer_code'] as String,
      customer_name: json['customer_name'] as String,
      customer_telephone: json['customer_telephone'] as String,
      total_amount: (json['total_amount'] as num).toDouble(),
      cashier_code: json['cashier_code'] as String,
      cashier_name: json['cashier_name'] as String,
      sale_code: json['sale_code'] as String,
      sale_name: json['sale_name'] as String,
      pay_cash_amount: (json['pay_cash_amount'] as num).toDouble(),
      sum_discount: (json['sum_discount'] as num).toDouble(),
      sum_qrcode: (json['sum_qrcode'] as num).toDouble(),
      sum_credit_card: (json['sum_credit_card'] as num).toDouble(),
      sum_coupon: (json['sum_coupon'] as num).toDouble(),
      sum_money_transfer: (json['sum_money_transfer'] as num).toDouble(),
      sum_cheque: (json['sum_cheque'] as num).toDouble(),
      bill_details: (json['bill_details'] as List<dynamic>)
          .map((e) => ApiBillDetailStruct.fromJson(e as Map<String, dynamic>))
          .toList(),
      pay_qrcodes: (json['pay_qrcodes'] as List<dynamic>)
          .map((e) => ApiBillPayQrStruct.fromJson(e as Map<String, dynamic>))
          .toList(),
      pay_credit_cards: (json['pay_credit_cards'] as List<dynamic>)
          .map((e) =>
              ApiBillPayCreditCardStruct.fromJson(e as Map<String, dynamic>))
          .toList(),
      pay_money_transfers: (json['pay_money_transfers'] as List<dynamic>)
          .map((e) =>
              ApiBillPayTransferStruct.fromJson(e as Map<String, dynamic>))
          .toList(),
      coupons: (json['coupons'] as List<dynamic>)
          .map(
              (e) => ApiBillPayCouponStruct.fromJson(e as Map<String, dynamic>))
          .toList(),
      pay_cheques: (json['pay_cheques'] as List<dynamic>)
          .map(
              (e) => ApiBillPayChequeStruct.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ApiBillStructToJson(ApiBillStruct instance) =>
    <String, dynamic>{
      'doc_number': instance.doc_number,
      'date_time': instance.date_time.toIso8601String(),
      'customer_code': instance.customer_code,
      'customer_name': instance.customer_name,
      'customer_telephone': instance.customer_telephone,
      'total_amount': instance.total_amount,
      'sale_code': instance.sale_code,
      'sale_name': instance.sale_name,
      'cashier_code': instance.cashier_code,
      'cashier_name': instance.cashier_name,
      'pay_cash_amount': instance.pay_cash_amount,
      'sum_discount': instance.sum_discount,
      'sum_qrcode': instance.sum_qrcode,
      'sum_credit_card': instance.sum_credit_card,
      'sum_money_transfer': instance.sum_money_transfer,
      'sum_cheque': instance.sum_cheque,
      'sum_coupon': instance.sum_coupon,
      'bill_details': instance.bill_details.map((e) => e.toJson()).toList(),
      'pay_qrcodes': instance.pay_qrcodes.map((e) => e.toJson()).toList(),
      'pay_credit_cards':
          instance.pay_credit_cards.map((e) => e.toJson()).toList(),
      'pay_money_transfers':
          instance.pay_money_transfers.map((e) => e.toJson()).toList(),
      'pay_cheques': instance.pay_cheques.map((e) => e.toJson()).toList(),
      'coupons': instance.coupons.map((e) => e.toJson()).toList(),
    };

ApiBillDetailStruct _$ApiBillDetailStructFromJson(Map<String, dynamic> json) =>
    ApiBillDetailStruct(
      doc_number: json['doc_number'] as String,
      date_time: DateTime.parse(json['date_time'] as String),
      line_number: json['line_number'] as int,
      barcode: json['barcode'] as String,
      item_code: json['item_code'] as String,
      item_name: json['item_name'] as String,
      unit_code: json['unit_code'] as String,
      unit_name: json['unit_name'] as String,
      qty: (json['qty'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      total_amount: (json['total_amount'] as num).toDouble(),
      discount_text: json['discount_text'] as String,
      discount: (json['discount'] as num).toDouble(),
      extra_details: (json['extra_details'] as List<dynamic>)
          .map((e) =>
              ApiBillDetailExtraStruct.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ApiBillDetailStructToJson(
        ApiBillDetailStruct instance) =>
    <String, dynamic>{
      'doc_number': instance.doc_number,
      'date_time': instance.date_time.toIso8601String(),
      'line_number': instance.line_number,
      'barcode': instance.barcode,
      'item_code': instance.item_code,
      'item_name': instance.item_name,
      'unit_code': instance.unit_code,
      'unit_name': instance.unit_name,
      'qty': instance.qty,
      'price': instance.price,
      'total_amount': instance.total_amount,
      'discount_text': instance.discount_text,
      'discount': instance.discount,
      'extra_details': instance.extra_details,
    };

ApiBillDetailExtraStruct _$ApiBillDetailExtraStructFromJson(
        Map<String, dynamic> json) =>
    ApiBillDetailExtraStruct(
      line_number: json['line_number'] as int,
      doc_number: json['doc_number'] as String,
      date_time: DateTime.parse(json['date_time'] as String),
      ref_line_number: json['ref_line_number'] as int,
      barcode: json['barcode'] as String,
      item_code: json['item_code'] as String,
      item_name: json['item_name'] as String,
      unit_code: json['unit_code'] as String,
      unit_name: json['unit_name'] as String,
      qty: (json['qty'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      total_amount: (json['total_amount'] as num).toDouble(),
    );

Map<String, dynamic> _$ApiBillDetailExtraStructToJson(
        ApiBillDetailExtraStruct instance) =>
    <String, dynamic>{
      'doc_number': instance.doc_number,
      'date_time': instance.date_time.toIso8601String(),
      'line_number': instance.line_number,
      'ref_line_number': instance.ref_line_number,
      'barcode': instance.barcode,
      'item_code': instance.item_code,
      'item_name': instance.item_name,
      'unit_code': instance.unit_code,
      'unit_name': instance.unit_name,
      'qty': instance.qty,
      'price': instance.price,
      'total_amount': instance.total_amount,
    };

ApiBillPayQrStruct _$ApiBillPayQrStructFromJson(Map<String, dynamic> json) =>
    ApiBillPayQrStruct(
      doc_number: json['doc_number'] as String,
      date_time: DateTime.parse(json['date_time'] as String),
      description: json['description'] as String,
      provider_code: json['provider_code'] as String,
      provider_name: json['provider_name'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$ApiBillPayQrStructToJson(ApiBillPayQrStruct instance) =>
    <String, dynamic>{
      'doc_number': instance.doc_number,
      'date_time': instance.date_time.toIso8601String(),
      'provider_code': instance.provider_code,
      'provider_name': instance.provider_name,
      'description': instance.description,
      'amount': instance.amount,
    };

ApiBillPayCreditCardStruct _$ApiBillPayCreditCardStructFromJson(
        Map<String, dynamic> json) =>
    ApiBillPayCreditCardStruct(
      doc_number: json['doc_number'] as String,
      date_time: DateTime.parse(json['date_time'] as String),
      edc_code: json['edc_code'] as String,
      card_number: json['card_number'] as String,
      approved_code: json['approved_code'] as String,
      edc_name: json['edc_name'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$ApiBillPayCreditCardStructToJson(
        ApiBillPayCreditCardStruct instance) =>
    <String, dynamic>{
      'doc_number': instance.doc_number,
      'date_time': instance.date_time.toIso8601String(),
      'edc_code': instance.edc_code,
      'edc_name': instance.edc_name,
      'card_number': instance.card_number,
      'approved_code': instance.approved_code,
      'amount': instance.amount,
    };

ApiBillPayTransferStruct _$ApiBillPayTransferStructFromJson(
        Map<String, dynamic> json) =>
    ApiBillPayTransferStruct(
      doc_number: json['doc_number'] as String,
      date_time: DateTime.parse(json['date_time'] as String),
      bank_code: json['bank_code'] as String,
      bank_name: json['bank_name'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$ApiBillPayTransferStructToJson(
        ApiBillPayTransferStruct instance) =>
    <String, dynamic>{
      'doc_number': instance.doc_number,
      'date_time': instance.date_time.toIso8601String(),
      'bank_code': instance.bank_code,
      'bank_name': instance.bank_name,
      'amount': instance.amount,
    };

ApiBillPayChequeStruct _$ApiBillPayChequeStructFromJson(
        Map<String, dynamic> json) =>
    ApiBillPayChequeStruct(
      doc_number: json['doc_number'] as String,
      date_time: DateTime.parse(json['date_time'] as String),
      due_date: DateTime.parse(json['due_date'] as String),
      bank_code: json['bank_code'] as String,
      bank_name: json['bank_name'] as String,
      branch_name: json['branch_name'] as String,
      cheque_number: json['cheque_number'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$ApiBillPayChequeStructToJson(
        ApiBillPayChequeStruct instance) =>
    <String, dynamic>{
      'doc_number': instance.doc_number,
      'date_time': instance.date_time.toIso8601String(),
      'bank_code': instance.bank_code,
      'bank_name': instance.bank_name,
      'branch_name': instance.branch_name,
      'due_date': instance.due_date.toIso8601String(),
      'cheque_number': instance.cheque_number,
      'amount': instance.amount,
    };

ApiBillPayCouponStruct _$ApiBillPayCouponStructFromJson(
        Map<String, dynamic> json) =>
    ApiBillPayCouponStruct(
      doc_number: json['doc_number'] as String,
      date_time: DateTime.parse(json['date_time'] as String),
      number: json['number'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$ApiBillPayCouponStructToJson(
        ApiBillPayCouponStruct instance) =>
    <String, dynamic>{
      'doc_number': instance.doc_number,
      'date_time': instance.date_time.toIso8601String(),
      'number': instance.number,
      'amount': instance.amount,
    };
