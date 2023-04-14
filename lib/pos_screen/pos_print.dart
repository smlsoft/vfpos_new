import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:charset_converter/charset_converter.dart';
import 'package:dedepos/pos_screen/pos_print_image.dart';
import 'package:dedepos/pos_screen/pos_print_text.dart';
import 'package:dedepos/services/print_process.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/db/bill_helper.dart';
import 'package:collection/collection.dart';
import 'package:dedepos/model/system/pos_pay_model.dart';
import 'package:promptpay/promptpay.dart';

void printBill(String docNo) {
  if (global.posTicket.printMode == 0) {
    printBillText(docNo);
  } else {
    printBillImage(docNo);
  }
}
