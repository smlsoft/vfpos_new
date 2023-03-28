import 'dart:async';
import '../api/sync/model/promotion_struct.dart';
import 'package:dedepos/global.dart' as global;

class PromotionHelper {
  int insert(PromotionStruct value) {
    return 0;
  }

  List<PromotionStruct> select(
      {String where = "", int limit = 0, int offset = 0}) {
    return [];
  }

  bool delete(String code) {
    return false;
  }

  bool update(PromotionStruct value)  {
    return false;
  }
}
