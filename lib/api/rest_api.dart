import 'package:dedepos/db/employee_helper.dart';
import 'package:dedepos/db/member_helper.dart';
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
    String _fieldName = "telephone,name";
    List<String> _fieldNameList = _fieldName.split(",");
    List<FindMemberModel> _result = [];
    if (word.trim().isNotEmpty) {
      MemberHelper _memberHelper = MemberHelper();

      StringBuffer _where = StringBuffer();

      List<String> _wordBreak = global.wordSplit(word);
      for (int _fieldIndex = 0;
          _fieldIndex < _fieldNameList.length;
          _fieldIndex++) {
        if (_where.isNotEmpty) {
          _where.write(" or ");
        }
        StringBuffer _whereField = StringBuffer();
        for (int _wordIndex = 0; _wordIndex < _wordBreak.length; _wordIndex++) {
          if (_whereField.isNotEmpty) {
            _whereField.write(" and ");
          }
          _whereField.write(" " +
              _fieldNameList[_fieldIndex] +
              " like '%" +
              _wordBreak[_wordIndex] +
              "%'");
        }
        _where.write(" (" + _whereField.toString() + ") ");
      }
      List<MemberObjectBoxStruct> _select =
          await _memberHelper.select(where: _where.toString());
      for (int _index = 0; _index < _select.length; _index++) {
        MemberObjectBoxStruct _source = _select[_index];
        _result.add(
          FindMemberModel(
            address: _source.address,
            branchcode: _source.branchcode,
            branchtype: _source.branchtype,
            contacttype: _source.contacttype,
            name: _source.name,
            personaltype: _source.personaltype,
            surname: _source.surname,
            taxid: _source.taxid,
            telephone: _source.telephone,
            zipcode: _source.zipcode,
          ),
        );
      }
    }
    return _result;
  }
}

class RestApiFindEmployeeByWord {
  Future<List<FindEmployeeModel>> findEmployeeByWord(String word) async {
    List<FindEmployeeModel> _result = [];
    EmployeeHelper _employeeHelper = EmployeeHelper();
    List<EmployeeObjectBoxStruct> _select =
        await _employeeHelper.select(word: word);
    for (int _index = 0; _index < _select.length; _index++) {
      EmployeeObjectBoxStruct _source = _select[_index];
      _result.add(
        FindEmployeeModel(
            name: _source.name,
            code: _source.code,
            roles: "" /* _source.roles.toString()*/,
            profilepicture: _source.profilepicture,
            username: _source.username),
      );
    }
    return _result;
  }
}
