import 'package:uuid/uuid.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class PosLogObjectBoxStruct {
  int id;

  /// GUID Log
  @Unique()
  String guid_auto_fixed = "";

  /// อ้างอิงในระบบ
  String guid_ref;

  /// รหัสอ้างอิง (สร้างอัตโนมัติ) เช่น กลุ่มตัวเลือก
  String guid_code_ref;

  /// วันที่+เวลา
  @Property(type: PropertyType.date)
  DateTime log_date_time;

  /// ลำดับการพักบิล
  int hold_number;

  /// คำสั่ง (หมายเหตุด้านล่าง)
  int command_code;

  /// ยกเลิกแล้ว
  int is_void;

  /// สำเร็จแล้ว
  int success;

  /// รหัสเพิ่มเติม
  String extra_code;

  /// หมายเหตุ
  String remark;

  /// ส่วนลด Text เช่น ลด 10%+5 บาท+6%=(10%,5,6%)
  String discountText;

  /// รหัสสินค้า
  String code;

  /// ราคา
  double price;

  /// ชื่อสินค้า
  String name;

  /// จำนวน
  double qty;

  /// จำนวนสูงสุด
  double qty_fixed;

  /// รหัสสินค้า (Default) งง
  String default_code;

  /// เลือกแล้ว
  bool selected;

  /// รหัสหน่วยนับ
  String unit_code;

  /// ชื่อหน่วยนับ
  String unit_name;

  /// Barcode
  String barcode;
  /* 
      -- command
      1=เพิ่มสินค้า
      2=เพิ่มจำนวน + 1
      3=ลดจำนวน - 1
      4=แก้จำนวน
      5=แก้ราคา
      6=แก้ส่วนลด
      8=หมายเหตุ
      9=ลบรายการสินค้า
      80=เปิดลิ้นชัก
      99=เริ่มใหม่
      100=Radio Extra
      101=Check Box Extra
  */

  PosLogObjectBoxStruct({
    this.id = 0,
    this.guid_ref = "",
    this.guid_code_ref = "",
    required this.log_date_time,
    required this.hold_number,
    required this.command_code,
    this.barcode = "",
    this.is_void = 0,
    this.success = 0,
    this.qty = 0,
    this.qty_fixed = 0,
    this.price = 0,
    this.selected = false,
    this.remark = "",
    this.name = "",
    this.code = "",
    this.default_code = "",
    this.discountText = "",
    this.extra_code = "",
    this.unit_code = "",
    this.unit_name = "",
  }) {
    this.guid_auto_fixed = Uuid().v4();
  }
}
