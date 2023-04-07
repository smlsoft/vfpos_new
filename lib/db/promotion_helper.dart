import 'dart:async';
import 'package:dedepos/api/sync/model/promotion_model.dart';
import 'package:dedepos/global.dart' as global;

class PromotionHelper {
  int insert(PromotionModel value) {
    return 0;
  }

  List<PromotionModel> select(
      {String where = "", int limit = 0, int offset = 0}) {
    return [];
  }

  bool delete(String code) {
    return false;
  }

  bool update(PromotionModel value) {
    return false;
  }
}
