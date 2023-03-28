import 'dart:async';
import '../model/json/product_bundle_struct.dart';
import 'package:dedepos/global.dart' as global;

class ProductBundleHelper {
  int insert(ProductBundleStruct productBundle) {
    return 0;
  }

   List<ProductBundleStruct> select(
      {required String where, int limit = 0, int offset = 0})  {
    if (where.isNotEmpty) where = " where " + where;
    return [];
  }

  bool delete(String barcode)  {
    return false;
  }

   bool update(ProductBundleStruct value)  {
    return false;
  }
}
