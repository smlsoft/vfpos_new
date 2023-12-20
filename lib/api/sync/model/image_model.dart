import 'package:dedepos/global_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image_model.g.dart';

@JsonSerializable()
class ImagesModel {
  String uri;
  int xorder;

  ImagesModel({
    required this.uri,
    required this.xorder,
  });

  factory ImagesModel.fromJson(Map<String, dynamic> json) => _$ImagesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesModelToJson(this);
}
