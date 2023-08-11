import 'dart:convert';

import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/objectbox/form_design_struct.dart';
import 'package:dedepos/services/print_process.dart';

Future<void> loadFormDesign() async {
  global.formDesignList = [];
  {
    List<FormDesignColumnModel> detailColumn = [
      FormDesignColumnModel(
          command_text:
              "&item_qty& &item_name&/&item_unit_name& &item_price_and_symbol& &item_discount&",
          header_names: [
            LanguageDataModel(code: "th", name: "รายละเอียด"),
            LanguageDataModel(code: "en", name: "Description"),
          ],
          font_weight_bold: true,
          width: 5),
      FormDesignColumnModel(
          command_text: "&item_total_amount&",
          text_align: PrintColumnAlign.right,
          header_names: [
            LanguageDataModel(code: "th", name: "รวม"),
            LanguageDataModel(code: "en", name: "Amount"),
          ],
          font_weight_bold: true,
          width: 2),
    ];
    List<FormDesignColumnModel> detailExtraColumn = [
      FormDesignColumnModel(
          command_text:
              " + &item_extra_name& &item_extra_qty& &item_extra_unit_name&",
          width: 5),
      FormDesignColumnModel(
          command_text: "&item_extra_price&",
          text_align: PrintColumnAlign.right,
          width: 1),
      FormDesignColumnModel(
          command_text: "&item_extra_total_amount&",
          text_align: PrintColumnAlign.right,
          width: 2),
    ];
    List<List<FormDesignColumnModel>> detailTotalColumn = [
      [
        // จำนวนชิ้น
        FormDesignColumnModel(command_text: "&total_piece_name&", width: 5),
        FormDesignColumnModel(
            command_text: "&total_piece&",
            text_align: PrintColumnAlign.right,
            width: 2),
      ],
      [
        // ยอดรวมสินค้ายกเว้นภาษี
        FormDesignColumnModel(
            command_text: "&total_itm_except_vat_amount_name&", width: 5),
        FormDesignColumnModel(
            command_text: "&total_itm_except_vat_amount&",
            text_align: PrintColumnAlign.right,
            width: 2),
      ],
      [
        // ยอดรวมสินค้ามีภาษี
        FormDesignColumnModel(
            command_text: "&total_item_vat_amount_name&", width: 5),
        FormDesignColumnModel(
            command_text: "&total_item_vat_amount&",
            text_align: PrintColumnAlign.right,
            width: 2),
      ],
      [
        // ยอดภาษี
        FormDesignColumnModel(command_text: "&total_vat_name&", width: 5),
        FormDesignColumnModel(
            command_text: "&total_vat&",
            text_align: PrintColumnAlign.right,
            width: 2),
      ],
      [
        // ยอดรวมสุทธิ
        FormDesignColumnModel(
            command_text: "&total_amount_name&",
            width: 5,
            font_size: 32,
            font_weight_bold: true),
        FormDesignColumnModel(
            command_text: "&total_amount&",
            text_align: PrintColumnAlign.right,
            font_weight_bold: true,
            font_size: 32,
            width: 2),
      ],
    ];

    // ใบสรุปยอด/ไม่ใช่ใบเสร็จรับเงิน
    global.formDesignList.add(FormDesignObjectBoxStruct(
        type: 0,
        guid_fixed: global.formSummery,
        code: global.formSummeryDefaultCode,
        sum_by_type: true,
        sum_by_barcode: true,
        print_logo: true,
        print_prompt_pay: true,
        names_json: jsonEncode(<LanguageDataModel>[
          LanguageDataModel(code: "th", name: "สรุปยอดเพื่อตรวจสอบ"),
          LanguageDataModel(code: "en", name: "Summary/non-receipt"),
        ]),
        header_json: "[{}]",
        detail_json: jsonEncode(detailColumn),
        detail_total_json: jsonEncode(detailTotalColumn),
        detail_extra_json: jsonEncode(detailExtraColumn),
        detail_footer_json: "{}",
        footer_json: "[{}]"));
  }
  {
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
          command_text:
              "&item_qty& &item_name&/&item_unit_name& &item_price_and_symbol& &item_discount&",
          header_names: [
            LanguageDataModel(code: "th", name: "รายละเอียด"),
            LanguageDataModel(code: "en", name: "Description"),
          ],
          font_weight_bold: true,
          width: 5),
      FormDesignColumnModel(
          command_text: "&item_total_amount&",
          text_align: PrintColumnAlign.right,
          header_names: [
            LanguageDataModel(code: "th", name: "รวม"),
            LanguageDataModel(code: "en", name: "Amount"),
          ],
          font_weight_bold: true,
          width: 2),
    ];
    List<FormDesignColumnModel> detailExtraColumn = [
      FormDesignColumnModel(
          command_text:
              " + &item_extra_name& &item_extra_qty& &item_extra_unit_name&",
          width: 5),
      FormDesignColumnModel(
          command_text: "&item_extra_price&",
          text_align: PrintColumnAlign.right,
          width: 1),
      FormDesignColumnModel(
          command_text: "&item_extra_total_amount&",
          text_align: PrintColumnAlign.right,
          width: 2),
    ];
    List<List<FormDesignColumnModel>> detailTotalColumn = [
      [
        // จำนวนชิ้น
        FormDesignColumnModel(command_text: "&total_piece_name&", width: 5),
        FormDesignColumnModel(
            command_text: "&total_piece&",
            text_align: PrintColumnAlign.right,
            width: 2),
      ],
      [
        // ยอดรวมสินค้ามีภาษี
        FormDesignColumnModel(
            condition_join_is_vat_register: 1,
            command_text: "&total_item_vat_amount_name&",
            width: 5),
        FormDesignColumnModel(
            command_text: "&total_item_vat_amount&",
            text_align: PrintColumnAlign.right,
            width: 2),
      ],
      [
        // ยอดรวมสินค้ายกเว้นภาษี
        FormDesignColumnModel(
            command_text: "&total_itm_except_vat_amount_name&", width: 5),
        FormDesignColumnModel(
            command_text: "&total_itm_except_vat_amount&",
            text_align: PrintColumnAlign.right,
            width: 2),
      ],
      [
        // ยอดส่วนลดสินค้ามีภาษี
        FormDesignColumnModel(
            condition_join_is_vat_register: 1,
            command_text: "&total_discount_vat_name&",
            width: 5),
        FormDesignColumnModel(
            command_text: "&total_discount_vat_amount&",
            text_align: PrintColumnAlign.right,
            width: 2),
      ],
      [
        // ยอดส่วนลดสินค้ายกเว้นภาษี
        FormDesignColumnModel(
            condition_join_is_vat_register: 1,
            command_text: "&total_discount_vat_except_name&",
            width: 5),
        FormDesignColumnModel(
            command_text: "&total_discount_vat_except_amount&",
            text_align: PrintColumnAlign.right,
            width: 2),
      ],
      [
        // ยอดส่วนลดทั้งหมด
        FormDesignColumnModel(command_text: "&total_discount_name&", width: 5),
        FormDesignColumnModel(
            command_text: "&total_discount_amount&",
            text_align: PrintColumnAlign.right,
            font_weight_bold: true,
            width: 2),
      ],
      [
        // ยอดก่อนภาษีมูลค่าเพิ่ม
        FormDesignColumnModel(
            condition_join_is_vat_register: 1,
            command_text: "&total_before_vat_name&",
            width: 5),
        FormDesignColumnModel(
            command_text: "&total_before_vat&",
            text_align: PrintColumnAlign.right,
            width: 2),
      ],
      [
        // ยอดภาษี
        FormDesignColumnModel(
            condition_join_is_vat_register: 1,
            command_text: "&total_vat_name&",
            width: 5),
        FormDesignColumnModel(
            condition_join_is_vat_register: 1,
            command_text: "&total_vat&",
            text_align: PrintColumnAlign.right,
            width: 2),
      ],
      [
        // มูลค่าหลังคิดภาษี
        FormDesignColumnModel(
            condition_join_is_vat_register: 1,
            command_text: "&total_item_vat_amount_after_discount_name&",
            width: 5),
        FormDesignColumnModel(
            condition_join_is_vat_register: 1,
            command_text: "&total_item_vat_amount_after_discount&",
            text_align: PrintColumnAlign.right,
            width: 2),
      ],
      [
        // มูลค่ายกเว้นภาษี
        FormDesignColumnModel(
            condition_join_is_vat_register: 1,
            command_text: "&total_item_except_vat_amount_after_discount_name&",
            width: 5),
        FormDesignColumnModel(
            condition_join_is_vat_register: 1,
            command_text: "&total_item_except_vat_amount_after_discount&",
            text_align: PrintColumnAlign.right,
            width: 2),
      ],
      [
        // ยอดรวมสุทธิ
        FormDesignColumnModel(
            command_text: "&total_amount_name&",
            width: 5,
            font_size: 32,
            font_weight_bold: true),
        FormDesignColumnModel(
            command_text: "&total_amount&",
            text_align: PrintColumnAlign.right,
            font_weight_bold: true,
            font_size: 32,
            width: 2),
      ],
      [
        // ชำระเงินสด
        FormDesignColumnModel(
            command_text: "&total_pay_cash_name&",
            width: 5,
            font_size: 32,
            font_weight_bold: true),
        FormDesignColumnModel(
            command_text: "&total_pay_cash&",
            text_align: PrintColumnAlign.right,
            width: 2,
            font_size: 32,
            font_weight_bold: true),
      ],
      [
        // เงินทอน
        FormDesignColumnModel(
            command_text: "&total_pay_cash_change_name&",
            width: 5,
            font_size: 32,
            font_weight_bold: true),
        FormDesignColumnModel(
            command_text: "&total_pay_cash_change&",
            text_align: PrintColumnAlign.right,
            width: 2,
            font_size: 32,
            font_weight_bold: true),
      ],
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

    // ใบเสร็จรับเงิน/ใบกำกับภาษีแบบย่อ
    global.formDesignList.add(FormDesignObjectBoxStruct(
      type: 0,
      guid_fixed: global.formReceiptsAndAbbreviatedTaxInvoices,
      code: global.formTaxDefaultCode,
      sum_by_type: true,
      sum_by_barcode: true,
      print_logo: true,
      print_prompt_pay: true,
      names_json: jsonEncode(<LanguageDataModel>[
        LanguageDataModel(code: "th", name: "ใบเสร็จรับเงิน/ใบกำกับภาษีแบบย่อ"),
        LanguageDataModel(code: "en", name: "Receipt/Tax invoice (short form)"),
      ]),
      header_json: jsonEncode(header),
      detail_json: jsonEncode(detailColumn),
      detail_total_json: jsonEncode(detailTotalColumn),
      detail_extra_json: jsonEncode(detailExtraColumn),
      detail_footer_json: "{}",
      footer_json: jsonEncode(footer),
    ));

    // ใบเสร็จรับเงิน/ใบกำกับภาษีแบบเต็ม (index = 2)
    global.formDesignList.add(FormDesignObjectBoxStruct(
      type: 0,
      guid_fixed: global.formFullReceiptAndTaxInvoice,
      code: global.formFullTaxDefaultCode,
      sum_by_type: true,
      sum_by_barcode: true,
      print_logo: true,
      print_prompt_pay: true,
      names_json: jsonEncode(<LanguageDataModel>[
        LanguageDataModel(
            code: "th", name: "ใบเสร็จรับเงิน/ใบกำกับภาษีแบบเต็ม"),
        LanguageDataModel(code: "en", name: "Receipt/Full Tax Invoice"),
      ]),
      header_json: jsonEncode(header),
      detail_json: jsonEncode(detailColumn),
      detail_total_json: jsonEncode(detailTotalColumn),
      detail_extra_json: jsonEncode(detailExtraColumn),
      detail_footer_json: "{}",
      footer_json: jsonEncode(footer),
    ));

    // ใบเสร็จรับเงิน (ไม่ได้จดทะเบียนเป็นผู้เสียภาษีมูลค่าเพิ่ม) (index = 3)
    global.formDesignList.add(FormDesignObjectBoxStruct(
      type: 0,
      guid_fixed: global.formReceipt,
      code: global.formFullTaxDefaultCode,
      sum_by_type: true,
      sum_by_barcode: true,
      print_logo: true,
      print_prompt_pay: true,
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
  }
}
