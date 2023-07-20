// ignore_for_file: non_constant_identifier_names

import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';

part 'table_struct.g.dart';

@Entity()
class TableObjectBoxStruct {
  int id = 0;
  @Unique()
  String guidfixed;
  String number;
  String numberMain;
  String names;
  String zone;

  TableObjectBoxStruct({
    required this.guidfixed,
    required this.number,
    required this.numberMain,
    required this.names,
    required this.zone,
  });
}

@JsonSerializable()
@Entity()
class TableProcessObjectBoxStruct {
  int id = 0;

  @Unique()
  final String guidfixed;
  final String number;
  late String number_main;
  final String names;
  late String zone;

  /// 0=ว่าง,1=เปิดโต๊ะแล้ว,2=ปิดโต๊ะแล้วรอคิดเงิน,3=รับชำระเงินแล้ว
  late int table_status;

  /// จำนวนรายการที่สั่ง
  late double order_count;

  /// ยอดเงิน (รวมทั้งหมด)
  late double amount;

  /// สถานะการสั่งอาหาร (False=ยังได้ไม่ครบ, True=ครบแล้ว)
  late bool order_success;

  /// เวลาเปิดโต๊ะ
  @Property(type: PropertyType.date)
  late DateTime table_open_datetime;

  /// Qr Code ล่าสุด
  late String qr_code;

  /// จำนวนคน ชาย
  late int man_count;

  /// จำนวนคน หญิง
  late int woman_count;

  /// จำนวนเด็ก
  late int child_count;

  /// False=สั่งแบบอลาคาร์ทไม่ได้,True=สั่งแบบอลาคาร์ทได้
  late bool table_al_la_crate_mode;

  /// Buffet ที่เลือก
  late String buffet_code;

  /// รหัสหรือเบอร์โทรศัพท์ลูกค้า
  late String customer_code_or_telephone;

  /// ชื่อลูกค้า
  late String customer_name;

  /// ที่อยู่ลูกค้า
  late String customer_address;

  /// Delivery ที่เลือก
  late String delivery_code;

  /// Delivery Ticket Number
  late String delivery_ticket_number;

  /// Delivery Number
  late String delivery_number;

  /// Remark
  late String remark;

  /// พนักงานที่เปิดโต๊ะ
  late String open_by_staff_code;

  /// ทำอาหารทันที
  late bool make_food_immediately;

  /// is Delivery
  late bool is_delivery;

  /// อาหารเสร็จแล้ว พร้อมเวลา
  late bool delivery_cook_success;
  @Property(type: PropertyType.date)
  late DateTime delivery_cook_success_datetime;

  /// ส่งอาหารแล้ว พร้อมเวลา
  late bool delivery_send_success;
  @Property(type: PropertyType.date)
  late DateTime delivery_send_success_datetime;

  /// สถานะ 0=รับที่ร้านรอคิดเงิน,1=คิดเงินแล้ว ทำส่ง Delivery
  late int delivery_status;

  /// จำนวนโต๊ะลูก (กรณีแยกโต๊ะ)
  late int table_child_count;

  TableProcessObjectBoxStruct({
    required this.guidfixed,
    required this.number,
    required this.number_main,
    required this.names,
    required this.zone,
    required this.table_status,
    required this.order_count,
    required this.amount,
    required this.order_success,
    required this.qr_code,
    required this.table_open_datetime,
    required this.man_count,
    required this.woman_count,
    required this.child_count,
    required this.table_al_la_crate_mode,
    required this.buffet_code,
    required this.customer_code_or_telephone,
    required this.customer_name,
    required this.customer_address,
    required this.delivery_code,
    required this.delivery_number,
    required this.delivery_ticket_number,
    required this.remark,
    required this.open_by_staff_code,
    required this.make_food_immediately,
    required this.is_delivery,
    required this.delivery_cook_success,
    required this.delivery_cook_success_datetime,
    required this.delivery_send_success,
    required this.delivery_send_success_datetime,
    required this.delivery_status,
    required this.table_child_count,
  });

  factory TableProcessObjectBoxStruct.fromJson(Map<String, dynamic> json) =>
      _$TableProcessObjectBoxStructFromJson(json);
  Map<String, dynamic> toJson() => _$TableProcessObjectBoxStructToJson(this);
}
