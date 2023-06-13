import 'package:dedepos/db/employee_helper.dart';
import 'package:dedepos/db/product_barcode_helper.dart';
import 'package:dedepos/model/objectbox/employees_struct.dart';
import 'package:dedepos/model/find/find_employee_model.dart';
import 'package:dedepos/model/find/find_member_model.dart';
import 'package:dedepos/model/objectbox/member_struct.dart';
import 'package:dedepos/model/find/find_item_model.dart';
import 'dart:async';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';

class RestApiFindItemByCodeNameBarcode {
  Future<List<FindItemModel>> findItemByCodeNameBarcode(
      String word, int offset, int limit) async {
    //String _fieldName = "barcode,code,name_1";
    List<FindItemModel> result = [];
    if (word.trim().isNotEmpty) {
      ProductBarcodeHelper productBarcodeHelper = ProductBarcodeHelper();
      List<ProductBarcodeObjectBoxStruct> select =
          productBarcodeHelper.selectByCodeNameBarCode(
              word: word.toString(), limit: limit, offset: offset, order: "");
      for (int index = 0; index < select.length; index++) {
        ProductBarcodeObjectBoxStruct source = select[index];
        List<double> packPrices = [];
        for (int priceIndex = 0;
            priceIndex < source.prices.length;
            priceIndex++) {
          packPrices.add(double.tryParse(source.prices[priceIndex]) ?? 0.0);
        }
        result.add(FindItemModel(
            barcode: source.barcode,
            item_code: "", // _source.code,
            item_names: source.names,
            unit_code: source.unit_code,
            unit_names: source.unit_names,
            unit_type: 0,
            qty: 1.0,
            prices: packPrices,
            images_guid_list: []));
      }
    }
    return result;
  }
}

class RestApiFindMemberByTelName {
  Future<List<FindMemberModel>> findMemberByTelName(
      String word, int offset, int limit) async {
    String fieldName = "telephone,name";
    List<String> fieldNameList = fieldName.split(",");
    List<FindMemberModel> result = [];
    if (word.trim().isNotEmpty) {}
    return result;
  }
}

class RestApiFindEmployeeByWord {
  Future<List<FindEmployeeModel>> findEmployeeByWord(String word) async {
    List<FindEmployeeModel> result = [];
    EmployeeHelper employeeHelper = EmployeeHelper();
    List<EmployeeObjectBoxStruct> select = employeeHelper.select(word: word);
    for (int index = 0; index < select.length; index++) {
      EmployeeObjectBoxStruct source = select[index];
      result.add(
        FindEmployeeModel(
            name: source.name,
            code: source.code,
            roles: "" /* _source.roles.toString()*/,
            profile_picture: source.profile_picture,
            username: source.name),
      );
    }
    return result;
  }
}
