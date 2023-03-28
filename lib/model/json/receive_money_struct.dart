// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'receive_money_struct.g.dart';

@JsonSerializable()
class ReceiveMoneyStruct {
  late DateTime create_date_time;
  late String doc_number;
  late String person_code;
  late double receive_money;

  ReceiveMoneyStruct(
      {required this.create_date_time,
      this.doc_number = "",
      this.person_code = "",
      this.receive_money = 0});
  factory ReceiveMoneyStruct.fromJson(Map<String, dynamic> json) =>
      _$ReceiveMoneyStructFromJson(json);
  Map<String, dynamic> toJson() => _$ReceiveMoneyStructToJson(this);
  /*ReceiveMoneyStruct.map(dynamic obj) {
    doc_number = obj["doc_number"];

    create_date_time = DateTime.tryParse(obj["create_date_time"])!;
    person_code = obj["emp_code"];
    receive_money = double.tryParse(obj["receive_money"].toString())!;
  }

  Map<String, dynamic> toMap() {
    var _map = <String, dynamic>{};

    _map["doc_number"] = doc_number;
    //  _map["create_date_time"] = createDatetime;
    _map["emp_code"] = person_code;
    _map["receive_money"] = receive_money;

    return _map;
  }*/
}
