import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

part 'pos_ticket_struct.g.dart';

@JsonSerializable()
@Entity()
class PosTicketObjectBoxStruct {
  int id = 0;
  @Unique()
  late String guidfixed;
  late String ticketName;
  late int printMode; // 0 = Raw (Text Mode), 1 = Image
  late int printerWidth;
  late bool logo;
  late bool shopName;
  late bool shopAddress;
  late bool shopTaxId;
  late bool shopTel;
  late bool cashierDetail;
  late bool customerDetail;
  late bool customerAddress;
  late bool customerTaxId;
  late double descriptionWidth;
  late double amountWidth;
  late bool saleDetail;
  late bool docNoQrCode;
  late int charPerLine;

  PosTicketObjectBoxStruct(
      {this.logo = true,
      this.printMode = 0,
      this.printerWidth = 640,
      this.guidfixed = "",
      this.ticketName = "",
      this.shopName = true,
      this.shopAddress = true,
      this.shopTaxId = true,
      this.shopTel = true,
      this.cashierDetail = true,
      this.customerDetail = true,
      this.customerAddress = true,
      this.customerTaxId = true,
      this.descriptionWidth = 40,
      this.amountWidth = 12,
      this.saleDetail = true,
      this.charPerLine = 48,
      this.docNoQrCode = true});

  factory PosTicketObjectBoxStruct.fromJson(Map<String, dynamic> json) =>
      _$PosTicketObjectBoxStructFromJson(json);
  Map<String, dynamic> toJson() => _$PosTicketObjectBoxStructToJson(this);
}
