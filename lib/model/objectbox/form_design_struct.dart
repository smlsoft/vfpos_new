import 'package:dedepos/global_model.dart';
import 'package:dedepos/services/print_process.dart';
import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';

part 'form_design_struct.g.dart';

@JsonSerializable(explicitToJson: true)
@Entity()
class FormDesignObjectBoxStruct {
  int id = 0;
  @Unique()
  String guid_fixed;
  @Unique()
  String code;
  // 0=ใบเสร็จรับเงิน,1=ใบสรุปยอด,2=ใบกำกับภาษีแบบเต็ม
  int type;
  String names_json;
  String header_json;
  String detail_json;
  String detail_extra_json;
  String detail_total_json;
  String detail_footer_json;
  String footer_json;

  FormDesignObjectBoxStruct({
    required this.guid_fixed,
    required this.code,
    required this.type,
    required this.names_json,
    required this.header_json,
    required this.detail_json,
    required this.detail_extra_json,
    required this.detail_total_json,
    required this.detail_footer_json,
    required this.footer_json,
  });

  factory FormDesignObjectBoxStruct.fromJson(Map<String, dynamic> json) =>
      _$FormDesignObjectBoxStructFromJson(json);
  Map<String, dynamic> toJson() => _$FormDesignObjectBoxStructToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FormDesignHeaderModel {
  List<List<LanguageDataModel>> description;

  FormDesignHeaderModel({
    required this.description,
  });

  factory FormDesignHeaderModel.fromJson(Map<String, dynamic> json) =>
      _$FormDesignHeaderModelFromJson(json);
  Map<String, dynamic> toJson() => _$FormDesignHeaderModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FormDesignFooterModel {
  List<List<LanguageDataModel>> description;
  bool print_qr_doc_no;

  FormDesignFooterModel({
    required this.description,
    required this.print_qr_doc_no,
  });

  factory FormDesignFooterModel.fromJson(Map<String, dynamic> json) =>
      _$FormDesignFooterModelFromJson(json);
  Map<String, dynamic> toJson() => _$FormDesignFooterModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class FormDesignColumnModel {
  List<LanguageDataModel> header_names;
  String command;
  double width;
  double font_size;
  String font_family;
  bool font_weight_bold;
  bool font_style_italic;
  bool decoration_underline;

  /// 0=Left,1=Center,2=Right
  PrintColumnAlign text_align;
  String background_color;
  String font_color;

  FormDesignColumnModel({
    required this.command,
    this.width = 1,
    this.header_names = const [],
    this.font_size = 12,
    this.font_family = "Arial",
    this.font_weight_bold = false,
    this.font_style_italic = false,
    this.decoration_underline = false,
    this.text_align = PrintColumnAlign.left,
    this.background_color = "",
    this.font_color = "",
  });

  factory FormDesignColumnModel.fromJson(Map<String, dynamic> json) =>
      _$FormDesignColumnModelFromJson(json);
  Map<String, dynamic> toJson() => _$FormDesignColumnModelToJson(this);
}
