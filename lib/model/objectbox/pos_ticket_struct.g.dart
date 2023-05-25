// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_ticket_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PosTicketObjectBoxStruct _$PosTicketObjectBoxStructFromJson(
        Map<String, dynamic> json) =>
    PosTicketObjectBoxStruct(
      logo: json['logo'] as bool? ?? true,
      printMode: json['printMode'] as int? ?? 0,
      printerWidth: json['printerWidth'] as int? ?? 640,
      guidfixed: json['guidfixed'] as String? ?? "",
      ticketName: json['ticketName'] as String? ?? "",
      shopName: json['shopName'] as bool? ?? true,
      shopAddress: json['shopAddress'] as bool? ?? true,
      shopTaxId: json['shopTaxId'] as bool? ?? true,
      shopTel: json['shopTel'] as bool? ?? true,
      cashierDetail: json['cashierDetail'] as bool? ?? true,
      customerDetail: json['customerDetail'] as bool? ?? true,
      customerAddress: json['customerAddress'] as bool? ?? true,
      customerTaxId: json['customerTaxId'] as bool? ?? true,
      descriptionWidth: (json['descriptionWidth'] as num?)?.toDouble() ?? 40,
      amountWidth: (json['amountWidth'] as num?)?.toDouble() ?? 12,
      saleDetail: json['saleDetail'] as bool? ?? true,
      docNoQrCode: json['docNoQrCode'] as bool? ?? true,
    )..id = json['id'] as int;

Map<String, dynamic> _$PosTicketObjectBoxStructToJson(
        PosTicketObjectBoxStruct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guidfixed': instance.guidfixed,
      'ticketName': instance.ticketName,
      'printMode': instance.printMode,
      'printerWidth': instance.printerWidth,
      'logo': instance.logo,
      'shopName': instance.shopName,
      'shopAddress': instance.shopAddress,
      'shopTaxId': instance.shopTaxId,
      'shopTel': instance.shopTel,
      'cashierDetail': instance.cashierDetail,
      'customerDetail': instance.customerDetail,
      'customerAddress': instance.customerAddress,
      'customerTaxId': instance.customerTaxId,
      'descriptionWidth': instance.descriptionWidth,
      'amountWidth': instance.amountWidth,
      'saleDetail': instance.saleDetail,
      'docNoQrCode': instance.docNoQrCode,
    };
