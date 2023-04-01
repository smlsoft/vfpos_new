import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/product_category_struct.dart';
import 'package:dedepos/objectbox.g.dart';

class ProductCategoryHelper {
  final box = global.objectBoxStore.box<ProductCategoryObjectBoxStruct>();

  int insert(ProductCategoryObjectBoxStruct value) {
    return box.put(value);
  }

  void insertMany(List<ProductCategoryObjectBoxStruct> values) {
    box.putMany(values);
  }

  List<ProductCategoryObjectBoxStruct> selectByParentCategoryGuidOrderByXorder(
      {String parentCategoryGuid = ""}) {
    print("[" + parentCategoryGuid + "]");
    return (box.query(ProductCategoryObjectBoxStruct_.parent_guid_fixed
            .equals(parentCategoryGuid))
          ..order(ProductCategoryObjectBoxStruct_.xorder))
        .build()
        .find();
  }

  ProductCategoryObjectBoxStruct? selectByCategoryGuidFindFirst(String guid) {
    print("[" + guid + "]");
    return box
        .query(ProductCategoryObjectBoxStruct_.guid_fixed.equals(guid))
        .build()
        .findFirst();
  }

  List<ProductCategoryObjectBoxStruct> selectByCategoryParentGuid(
      String parentGuid) {
    print("[" + parentGuid + "]");
    return box
        .query(ProductCategoryObjectBoxStruct_.parent_guid_fixed
            .equals(parentGuid))
        .order(ProductCategoryObjectBoxStruct_.xorder)
        .build()
        .find();
  }

  bool deleteByGuidFixed(String guidfixed) {
    bool result = false;
    final find = box
        .query(ProductCategoryObjectBoxStruct_.guid_fixed.equals(guidfixed))
        .build()
        .findFirst();
    if (find != null) {
      result = box.remove(find.id);
    }
    return result;
  }

  void deleteByGuidFixedMany(List<String> guidFixed) {
    Condition<ProductCategoryObjectBoxStruct>? ids;
    for (var guid in guidFixed) {
      if (ids == null) {
        ids = ProductCategoryObjectBoxStruct_.guid_fixed.equals(guid);
      } else {
        ids = ids.or(ProductCategoryObjectBoxStruct_.guid_fixed.equals(guid));
      }
    }
    if (ids != null) {
      final find = box.query(ids).build().find();
      box.removeMany(find.map((data) => data.id).toList());
    }
  }

  bool deleteByGuid(String guid) {
    bool result = false;
    final find = box
        .query(ProductCategoryObjectBoxStruct_.guid_fixed.equals(guid))
        .build()
        .findFirst();
    if (find != null) {
      result = box.remove(find.id);
    }
    return result;
  }

  void deleteAll() {
    box.removeAll();
  }

  int count() {
    return box.count();
  }
}
