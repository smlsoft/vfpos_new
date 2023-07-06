// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_temp_struct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderTempStruct _$OrderTempStructFromJson(Map<String, dynamic> json) =>
    OrderTempStruct(
      orderQty: (json['orderQty'] as num).toDouble(),
      orderTemp: (json['orderTemp'] as List<dynamic>)
          .map((e) =>
              OrderTempObjectBoxStruct.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderTempStructToJson(OrderTempStruct instance) =>
    <String, dynamic>{
      'orderQty': instance.orderQty,
      'orderTemp': instance.orderTemp.map((e) => e.toJson()).toList(),
    };

OrderTempObjectBoxStruct _$OrderTempObjectBoxStructFromJson(
        Map<String, dynamic> json) =>
    OrderTempObjectBoxStruct(
      id: json['id'] as int,
      orderId: json['orderId'] as String,
      orderGuid: json['orderGuid'] as String,
      machineId: json['machineId'] as String,
      orderDateTime: DateTime.parse(json['orderDateTime'] as String),
      barcode: json['barcode'] as String,
      qty: (json['qty'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      isClose: json['isClose'] as int,
      optionSelected: json['optionSelected'] as String,
      remark: json['remark'] as String,
      names: json['names'] as String,
      unitCode: json['unitCode'] as String,
      unitName: json['unitName'] as String,
      imageUri: json['imageUri'] as String,
      kdsSuccessTime: DateTime.parse(json['kdsSuccessTime'] as String),
      kdsSuccess: json['kdsSuccess'] as bool,
      kdsCancel: json['kdsCancel'] as bool,
      kdsId: json['kdsId'] as String,
    );

Map<String, dynamic> _$OrderTempObjectBoxStructToJson(
        OrderTempObjectBoxStruct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'orderGuid': instance.orderGuid,
      'machineId': instance.machineId,
      'orderDateTime': instance.orderDateTime.toIso8601String(),
      'barcode': instance.barcode,
      'qty': instance.qty,
      'price': instance.price,
      'amount': instance.amount,
      'isClose': instance.isClose,
      'optionSelected': instance.optionSelected,
      'remark': instance.remark,
      'names': instance.names,
      'unitCode': instance.unitCode,
      'unitName': instance.unitName,
      'imageUri': instance.imageUri,
      'kdsSuccessTime': instance.kdsSuccessTime.toIso8601String(),
      'kdsSuccess': instance.kdsSuccess,
      'kdsCancel': instance.kdsCancel,
      'kdsId': instance.kdsId,
    };
