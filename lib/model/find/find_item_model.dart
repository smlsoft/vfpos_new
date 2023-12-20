// ignore_for_file: non_constant_identifier_names

import 'package:dedepos/global_model.dart';

class FindItemModel {
  late String barcode;
  late String item_code;
  late String item_names;
  late String unit_code;
  late String unit_names;
  late int unit_type;
  late String prices;
  late List<String> images_guid_list;
  late double qty;

  FindItemModel(
      {required this.barcode,
      required this.item_code,
      required this.item_names,
      required this.unit_code,
      required this.unit_names,
      required this.unit_type,
      required this.qty,
      required this.prices,
      required this.images_guid_list});
}
