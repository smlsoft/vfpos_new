import '../model/json/product_bundle_model.dart';

class ProductBundleHelper {
  int insert(ProductBundleModel productBundle) {
    return 0;
  }

  List<ProductBundleModel> select(
      {required String where, int limit = 0, int offset = 0}) {
    if (where.isNotEmpty) where = " where $where";
    return [];
  }

  bool delete(String barcode) {
    return false;
  }

  bool update(ProductBundleModel value) {
    return false;
  }
}
