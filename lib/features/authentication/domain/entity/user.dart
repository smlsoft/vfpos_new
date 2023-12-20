import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

part 'user.g.dart';

@freezed
class User with _$User {
  factory User({
    @Default('') String name,
    @Default('') String username,
    @Default('') String token,
    @Default('') String refresh,
    @Default(0) int isDev,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
