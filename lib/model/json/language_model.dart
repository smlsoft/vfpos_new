import 'package:json_annotation/json_annotation.dart';

part 'language_model.g.dart';

class LanguageModel {
  String code;
  String codeTranslator;
  String name;
  bool use;

  LanguageModel(
      {required this.code,
      required this.codeTranslator,
      required this.name,
      required this.use});
}

@JsonSerializable(explicitToJson: true)
class LanguageDataModel {
  String code;
  String name;

  LanguageDataModel({required this.code, required this.name});

  factory LanguageDataModel.fromJson(Map<String, dynamic> json) =>
      _$LanguageDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageDataModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LanguageSystemModel {
  String code;
  String text;

  LanguageSystemModel({required this.code, required this.text});

  factory LanguageSystemModel.fromJson(Map<String, dynamic> json) =>
      _$LanguageSystemModelFromJson(json);
  Map<String, dynamic> toJson() => _$LanguageSystemModelToJson(this);
}

/*@JsonSerializable(explicitToJson: true)
class LanguageSystemCodeModel {
  String code;
  List<LanguageSystemModel> langs;

  LanguageSystemCodeModel({required this.code, required this.langs});

  factory LanguageSystemCodeModel.fromJson(Map<String, dynamic> json) =>
      _$LanguageSystemCodeModelFromJson(json);
  Map<String, dynamic> toJson() => _$LanguageSystemCodeModelToJson(this);
}
*/