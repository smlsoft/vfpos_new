// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'print_queue_struct.g.dart';

@JsonSerializable()
class PrintQueueStruct {
  late String guid;
  late int code; // 1=Bill,2=Kitchen Order,9=ใบสรุปใบสั่งอาหาร,10=เปิดโต๊ะ
  late String doc_number;
  late int line_number;
  late String printer_code;

  PrintQueueStruct(
      {required this.code,
      required this.doc_number,
      this.line_number = 0,
      required this.printer_code})
      : this.guid = Uuid().v4();
  factory PrintQueueStruct.fromJson(Map<String, dynamic> json) =>
      _$PrintQueueStructFromJson(json);
  Map<String, dynamic> toJson() => _$PrintQueueStructToJson(this);
  /*PrintQueueStruct.map(dynamic obj) {
    idx = obj["idx"];
    code = obj["code"];
    doc_number = obj["doc_number"];
    line_number = obj["line_number"];
    printer_code = obj["printer_code"];
  }

  Map<String, dynamic> toMap() {
    var _map = <String, dynamic>{};

    _map["code"] = code;
    _map["doc_number"] = doc_number;
    _map["line_number"] = line_number;
    _map["printer_code"] = printer_code;

    return _map;
  }

  Map toJson() => {
        "code": code,
        "doc_number": doc_number,
        "line_number": line_number,
        "printer_code": printer_code,
      };

  factory PrintQueueStruct.fromJson(Map<String, dynamic> obj) {
    return PrintQueueStruct(
      code: obj["code"],
      doc_number: obj["doc_number"],
      line_number: obj["line_number"],
      printer_code: obj["printer_code"],
    );
  }*/
}