import 'package:dedepos/model/json/struct.dart';

class ApiBarcodeResultModel {
  List<BarcodeStruct>? barcodes;

  ApiBarcodeResultModel({barcodes});

  ApiBarcodeResultModel.fromJson(Map<String, dynamic> json) {
    barcodes = [];
  }
}
