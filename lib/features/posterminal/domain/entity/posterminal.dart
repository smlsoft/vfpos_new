import 'package:freezed_annotation/freezed_annotation.dart';

part 'posterminal.freezed.dart';
part 'posterminal.g.dart';

@freezed
class Posterminal with _$Posterminal {
  const factory Posterminal({
    @Default('') String shopid,
    @Default('') String guidfixed,
    @Default('') String name,
    @Default('') String name1,
    @Default('') String branchcode,
    @Default(0) int role,
    @Default(false) bool isfavorite,
    @Default('') String lastaccessedat,
  }) = _Posterminal;

  factory Posterminal.fromJson(Map<String, dynamic> json) => _$PosterminalFromJson(json);
}
