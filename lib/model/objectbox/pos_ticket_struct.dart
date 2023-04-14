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
  late int printMode; // 0 = Raw, 1 = Image
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
  late bool lineNumber;
  late bool qty;
  late double descriptionWidth;
  late double qtyWidth;
  late double priceWidth;
  late double amountWidth;
  late bool saleDetail;
  late bool docNoQrCode;

  PosTicketObjectBoxStruct(
      {this.logo = true,
      this.printMode = 1,
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
      this.lineNumber = true,
      this.qty = true,
      this.descriptionWidth = 40,
      this.qtyWidth = 10,
      this.priceWidth = 12,
      this.amountWidth = 15,
      this.saleDetail = true,
      this.docNoQrCode = true});

  factory PosTicketObjectBoxStruct.fromJson(Map<String, dynamic> json) =>
      _$PosTicketObjectBoxStructFromJson(json);
  Map<String, dynamic> toJson() => _$PosTicketObjectBoxStructToJson(this);
}
