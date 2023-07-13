import 'dart:convert';

import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/objectbox/form_design_struct.dart';
import 'package:dedepos/services/print_process.dart';

void loadFormDesign() {
  global.formDesignList = [];

  FormDesignHeaderModel header = FormDesignHeaderModel(description: [
    [
      LanguageDataModel(code: "th", name: "สวัสดีปีใหม่ 2564"),
      LanguageDataModel(code: "th", name: "Happy New Year 2021")
    ],
    [
      LanguageDataModel(code: "th", name: "ยินดีแขกมาเยือน"),
      LanguageDataModel(code: "th", name: "welcome guests")
    ]
  ]);
  List<FormDesignColumnModel> detailColumn = [
    FormDesignColumnModel(
        command:
            "&item_qty& &item_name&/&item_unit_name& &item_price_and_symbol& &item_discount&",
        header_names: [
          LanguageDataModel(code: "th", name: "รายละเอียด"),
          LanguageDataModel(code: "en", name: "Description"),
        ],
        width: 5),
    FormDesignColumnModel(
        command: "&item_total_amount&",
        text_align: PrintColumnAlign.right,
        header_names: [
          LanguageDataModel(code: "th", name: "รวม"),
          LanguageDataModel(code: "en", name: "Amount"),
        ],
        width: 2),
  ];
  List<FormDesignColumnModel> detailExtraColumn = [
    FormDesignColumnModel(
        command: " + &item_extra_name& &item_extra_qty& &item_extra_unit_name&",
        width: 5),
    FormDesignColumnModel(
        command: "&item_extra_price&",
        text_align: PrintColumnAlign.right,
        width: 1),
    FormDesignColumnModel(
        command: "&item_extra_total_amount&",
        text_align: PrintColumnAlign.right,
        width: 2),
  ];
  List<FormDesignColumnModel> detailTotalColumn = [
    FormDesignColumnModel(command: "&item_name&", width: 5),
    FormDesignColumnModel(
        command: "&total_piece&", text_align: PrintColumnAlign.right, width: 1),
    FormDesignColumnModel(
        command: "&total_amount&",
        text_align: PrintColumnAlign.right,
        width: 2),
  ];
  FormDesignFooterModel footer = FormDesignFooterModel(description: [
    [
      LanguageDataModel(code: "th", name: "ขอบคุณที่ใช้บริการ"),
      LanguageDataModel(code: "th", name: "Thank you for using the service.")
    ],
    [
      LanguageDataModel(code: "th", name: "แล้วพบกันใหม่"),
      LanguageDataModel(code: "th", name: "meet again")
    ]
  ], print_qr_doc_no: true);

  // ใบเสร็จรับเงิน
  global.formDesignList.add(FormDesignObjectBoxStruct(
    type: 0,
    guid_fixed: "",
    code: global.formBillDefaultCode,
    names_json: jsonEncode(<LanguageDataModel>[
      LanguageDataModel(code: "th", name: "ใบเสร็จรับเงิน"),
      LanguageDataModel(code: "en", name: "Receipt"),
    ]),
    header_json: jsonEncode(header),
    detail_json: jsonEncode(detailColumn),
    detail_total_json: jsonEncode(detailTotalColumn),
    detail_extra_json: jsonEncode(detailExtraColumn),
    detail_footer_json: "{}",
    footer_json: jsonEncode(footer),
  ));

  // ใบสรุปยอด/ไม่ใช่ใบเสร็จรับเงิน
  global.formDesignList.add(FormDesignObjectBoxStruct(
    type: 0,
    guid_fixed: "",
    code: global.formSummeryDefaultCode,
    names_json: jsonEncode(<LanguageDataModel>[
      LanguageDataModel(code: "th", name: "ใบสรุปยอด/ไม่ใช่ใบเสร็จรับเงิน"),
      LanguageDataModel(code: "en", name: "Summary/non-receipt"),
    ]),
    header_json: jsonEncode(header),
    detail_json: jsonEncode(detailColumn),
    detail_total_json: jsonEncode(detailTotalColumn),
    detail_extra_json: jsonEncode(detailExtraColumn),
    detail_footer_json: "{}",
    footer_json: jsonEncode(footer),
  ));
}
