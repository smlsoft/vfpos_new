import 'package:dedepos/global_model.dart';
import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_temp_struct.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderTempStruct {
  double orderQty;
  List<OrderTempObjectBoxStruct> orderTemp;

  OrderTempStruct({
    required this.orderQty,
    required this.orderTemp,
  });

  factory OrderTempStruct.fromJson(Map<String, dynamic> json) =>
      _$OrderTempStructFromJson(json);

  Map<String, dynamic> toJson() => _$OrderTempStructToJson(this);
}

@JsonSerializable(explicitToJson: true)
@Entity()
class OrderTempObjectBoxStruct {
  int id;

  /// รหัส Order (โทรศัพท์,GUID โต๊ะ)
  String orderId;

  /// รหัส อ้างอิง
  String orderGuid;

  /// UUID หน้าจอกรณีเลือกพร้อมกันหลายคน
  String machineId;
  DateTime orderDateTime;
  String barcode;
  double qty;
  double price;
  double amount;

  /// สถานะล่าสุด 0=กำลังรับ Order,1=กำลังส่ง Order,2=ส่ง Order แล้ว (ไปครัว)
  int isClose;
  String optionSelected;
  String remark;
  String names;
  String unitCode;
  String unitName;
  String imageUri;

  /// KDS System
  DateTime kdsSuccessTime;
  bool kdsSuccess;
  bool kdsCancel;
  String kdsId;

  OrderTempObjectBoxStruct({
    required this.id,
    required this.orderId,
    required this.orderGuid,
    required this.machineId,
    required this.orderDateTime,
    required this.barcode,
    required this.qty,
    required this.price,
    required this.amount,
    required this.isClose,
    required this.optionSelected,
    required this.remark,
    required this.names,
    required this.unitCode,
    required this.unitName,
    required this.imageUri,
    required this.kdsSuccessTime,
    required this.kdsSuccess,
    required this.kdsCancel,
    required this.kdsId,
  });

  factory OrderTempObjectBoxStruct.fromJson(Map<String, dynamic> json) =>
      _$OrderTempObjectBoxStructFromJson(json);
  Map<String, dynamic> toJson() => _$OrderTempObjectBoxStructToJson(this);
}
