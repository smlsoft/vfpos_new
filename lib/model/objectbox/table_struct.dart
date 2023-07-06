import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';

part 'table_struct.g.dart';

@Entity()
class TableObjectBoxStruct {
  int id = 0;
  @Unique()
  String guidfixed;
  String number;
  String names;
  String zone;

  TableObjectBoxStruct({
    required this.guidfixed,
    required this.number,
    required this.names,
    required this.zone,
  });
}

@JsonSerializable()
@Entity()
class TableProcessObjectBoxStruct {
  int id = 0;
  @Unique()
  String guidfixed;
  String number;
  String names;
  String zone;

  /// 0=เปิดโต๊ะ,1=ปิดโต๊ะ
  int table_status;

  /// จำนวนที่สั่ง
  double order_count;

  /// ยอดเงินทั้งหมด
  double amount;

  /// สถานะการสั่งอาหาร (False=ยังได้ไม่ครบ, True=ครบแล้ว)
  bool order_success;

  /// เวลาเปิดโต๊ะ
  DateTime table_open_datetime;

  /// Qr Code ล่าสุด
  String qr_code;

  /// จำนวนคน ชาย
  int man_count;

  /// จำนวนคน หญิง
  int woman_count;

  /// จำนวนเด็ก
  int child_count;

  /// False=สั่งแบบอลาคาร์ทไม่ได้,True=สั่งแบบอลาคาร์ทได้
  bool table_al_la_crate_mode;

  /// Buffet ที่เลือก
  String buffet_code;

  TableProcessObjectBoxStruct({
    required this.guidfixed,
    required this.number,
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
  });

  factory TableProcessObjectBoxStruct.fromJson(Map<String, dynamic> json) =>
      _$TableProcessObjectBoxStructFromJson(json);
  Map<String, dynamic> toJson() => _$TableProcessObjectBoxStructToJson(this);
}
