import 'package:dedepos/model/json/pos_model.dart';

class ApiBarcodeResultModel {
  List<BarcodeModel>? barcodes;

  ApiBarcodeResultModel({barcodes});

  ApiBarcodeResultModel.fromJson(Map<String, dynamic> json) {
    barcodes = [];
  }
}
