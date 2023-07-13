// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillDetailObjectBoxStruct _$BillDetailObjectBoxStructFromJson(
        Map<String, dynamic> json) =>
    BillDetailObjectBoxStruct(
      line_number: json['line_number'] as int? ?? 0,
      barcode: json['barcode'] as String? ?? "",
      item_code: json['item_code'] as String? ?? "",
      item_name: json['item_name'] as String? ?? "",
      unit_code: json['unit_code'] as String? ?? "",
      unit_name: json['unit_name'] as String? ?? "",
      sku: json['sku'] as String? ?? "",
      qty: (json['qty'] as num?)?.toDouble() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discount_text: json['discount_text'] as String? ?? "",
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      extra_json: json['extra_json'] as String? ?? "{}",
      total_amount: (json['total_amount'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$BillDetailObjectBoxStructToJson(
        BillDetailObjectBoxStruct instance) =>
    <String, dynamic>{
      'line_number': instance.line_number,
      'barcode': instance.barcode,
      'item_code': instance.item_code,
      'item_name': instance.item_name,
      'unit_code': instance.unit_code,
      'unit_name': instance.unit_name,
      'sku': instance.sku,
      'qty': instance.qty,
      'price': instance.price,
      'discount_text': instance.discount_text,
      'discount': instance.discount,
      'total_amount': instance.total_amount,
      'extra_json': instance.extra_json,
    };

BillDetailExtraObjectBoxStruct _$BillDetailExtraObjectBoxStructFromJson(
        Map<String, dynamic> json) =>
    BillDetailExtraObjectBoxStruct(
      barcode: json['barcode'] as String? ?? "",
      item_code: json['item_code'] as String? ?? "",
      item_name: json['item_name'] as String? ?? "",
      unit_code: json['unit_code'] as String? ?? "",
      unit_name: json['unit_name'] as String? ?? "",
      qty: (json['qty'] as num?)?.toDouble() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      total_amount: (json['total_amount'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$BillDetailExtraObjectBoxStructToJson(
        BillDetailExtraObjectBoxStruct instance) =>
    <String, dynamic>{
      'barcode': instance.barcode,
      'item_code': instance.item_code,
      'item_name': instance.item_name,
      'unit_code': instance.unit_code,
      'unit_name': instance.unit_name,
      'qty': instance.qty,
      'price': instance.price,
      'total_amount': instance.total_amount,
    };

BillPayObjectBoxStruct _$BillPayObjectBoxStructFromJson(
        Map<String, dynamic> json) =>
    BillPayObjectBoxStruct(
      trans_flag: json['trans_flag'] as int? ?? 0,
      bank_code: json['bank_code'] as String? ?? "",
      card_number: json['card_number'] as String? ?? "",
      approved_code: json['approved_code'] as String? ?? "",
      bank_name: json['bank_name'] as String? ?? "",
      bank_account_no: json['bank_account_no'] as String? ?? "",
      branch_number: json['branch_number'] as String? ?? "",
      bank_reference: json['bank_reference'] as String? ?? "",
      cheque_number: json['cheque_number'] as String? ?? "",
      code: json['code'] as String? ?? "",
      description: json['description'] as String? ?? "",
      number: json['number'] as String? ?? "",
      reference_one: json['reference_one'] as String? ?? "",
      reference_two: json['reference_two'] as String? ?? "",
      provider_code: json['provider_code'] as String? ?? "",
      provider_name: json['provider_name'] as String? ?? "",
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
    )
      ..doc_date_time = DateTime.parse(json['doc_date_time'] as String)
      ..due_date = DateTime.parse(json['due_date'] as String);

Map<String, dynamic> _$BillPayObjectBoxStructToJson(
        BillPayObjectBoxStruct instance) =>
    <String, dynamic>{
      'trans_flag': instance.trans_flag,
      'bank_code': instance.bank_code,
      'bank_name': instance.bank_name,
      'bank_account_no': instance.bank_account_no,
      'card_number': instance.card_number,
      'approved_code': instance.approved_code,
      'doc_date_time': instance.doc_date_time.toIso8601String(),
      'branch_number': instance.branch_number,
      'bank_reference': instance.bank_reference,
      'due_date': instance.due_date.toIso8601String(),
      'cheque_number': instance.cheque_number,
      'code': instance.code,
      'description': instance.description,
      'number': instance.number,
      'reference_one': instance.reference_one,
      'reference_two': instance.reference_two,
      'provider_code': instance.provider_code,
      'provider_name': instance.provider_name,
      'amount': instance.amount,
    };
