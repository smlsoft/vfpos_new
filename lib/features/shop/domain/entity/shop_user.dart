import 'package:freezed_annotation/freezed_annotation.dart';

import 'shop.dart';

part 'shop_user.freezed.dart';
part 'shop_user.g.dart';

@freezed
class ShopUser with _$ShopUser {
  const ShopUser._();
  const factory ShopUser({
    @Default('') String shopid,
    @Default('') String name,
    @Default('') String branchcode,
    @Default(0) int role,
    @Default(false) bool isfavorite,
    @Default('') String lastaccessedat,
  }) = _ShopUser;

  factory ShopUser.fromJson(Map<String, dynamic> json) =>
      _$ShopUserFromJson(json);

  Shop get toShop {
    return Shop(guidfixed: shopid, name1: name, branchcode: branchcode);
  }
}
