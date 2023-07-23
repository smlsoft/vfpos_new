// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/objectbox/pos_log_struct.dart';
import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/api/sync/model/promotion_model.dart';
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';

class PosProcess {
  PosProcessModel processResult = PosProcessModel(
      details: [], select_promotion_temp_list: [], promotion_list: []);

  PosProcessResultModel result = PosProcessResultModel();

  void sumCategoryCount({required PosProcessModel value}) {
    for (var product in global.productListByCategory) {
      product.product_count = 0;
      for (var transDetail in value.details) {
        if (product.barcode == transDetail.barcode &&
            transDetail.is_void == false) {
          product.product_count += transDetail.qty;
        }
      }
    }
  }

  int findByBarCodeAndPrice(String barcode, double price,
      {bool lastLineOnly = false}) {
    int result = -1;
    if (lastLineOnly) {
      if (processResult.details.isNotEmpty) {
        int index = processResult.details.length - 1;
        if (barcode == processResult.details[index].barcode &&
            price == processResult.details[index].price &&
            processResult.details[index].is_void == false) {
          result = index;
        }
      }
    } else {
      for (int index = 0; index < processResult.details.length; index++) {
        if (barcode == processResult.details[index].barcode &&
            price == processResult.details[index].price &&
            processResult.details[index].is_void == false) {
          result = index;
          break;
        }
      }
    }
    return result;
  }

  int findByGuid(String guid) {
    int result = -1;
    for (int index = 0; index < processResult.details.length; index++) {
      if (guid == processResult.details[index].guid) {
        result = index;
        break;
      }
    }
    return result;
  }

  void processCalc(int index) {
    for (int extraIndex = 0;
        extraIndex < processResult.details[index].extra.length;
        extraIndex++) {
      processResult.details[index].extra[extraIndex].qty =
          processResult.details[index].qty;
      processResult.details[index].extra[extraIndex].total_amount =
          processResult.details[index].extra[extraIndex].qty *
              (processResult.details[index].extra[extraIndex].price);
    }
    if (processResult.details.isNotEmpty &&
        index < processResult.details.length) {
      double calc = double.parse((processResult.details[index].qty *
              (processResult.details[index].price))
          .toStringAsFixed(2));
      processResult.details[index].total_amount =
          double.parse((calc).toStringAsFixed(2));
      processResult.details[index].total_amount_with_extra =
          processResult.details[index].total_amount;
      for (var extra in processResult.details[index].extra) {
        processResult.details[index].total_amount_with_extra +=
            extra.total_amount;
      }
    }
  }

  Future<PosProcessModel> process(
      {required String holdCode,
      required int docMode,
      required String discountFormula}) async {
    double totalAmount = 0;
    // ค้นหา Barcode
    List<PosLogObjectBoxStruct> valueLog = global.posLogHelper
        .selectByHoldCodeIsVoidSuccess(
            holdCode: holdCode, isVoid: 0, success: 0, docMode: docMode);

    int count = 0;
    for (int index = 0; index < valueLog.length; index++) {
      // ประมวลผล จำนวน,ราคา
      PosLogObjectBoxStruct logData = valueLog[index];
      //print('Command : ' + _index.toString() + " " + _logData.commandCode.toString() + " " + _logData.command.toString());
      /* 
        -- command
        1=เพิ่มสินค้า
        2=เพิ่มจำนวน + 1
        3=ลดจำนวน - 1
        4=แก้จำนวน
        5=แก้ราคา
        6=แก้ส่วนลด
        8=หมายเหตุ
        9=ลบรายการสินค้า
        80=เปิดลิ้นชัก
        99=เริ่มใหม่
        101=Check Box Extra
      */
      result.lastCommandCode = logData.command_code;
      switch (logData.command_code) {
        case 101:
          // 101=Check Box Extra
          if (logData.is_void == 0) {
            int findIndex = findByGuid(logData.guid_ref);
            if (findIndex != -1) {
              // เพิ่มบรรทัด (Extra)
              PosProcessDetailExtraModel extra = PosProcessDetailExtraModel();
              extra.index = processResult.details[findIndex].extra.length + 1;
              extra.guid_auto_fixed = logData.code;
              extra.guid_code_or_ref = logData.guid_code_ref;
              extra.barcode = "";
              extra.item_code = logData.code;
              extra.item_name = logData.name;
              extra.price = logData.price;
              extra.qty = logData.qty;
              extra.qty_fixed = logData.qty_fixed;
              extra.total_amount =
                  double.parse((extra.price * extra.qty).toStringAsFixed(2));
              extra.unit_code = "";
              extra.unit_name = "";
              extra.guid_auto_fixed = logData.guid_auto_fixed;
              extra.is_void = processResult.details[findIndex].is_void;
              double calc = double.parse((extra.price).toStringAsFixed(2));
              extra.total_amount = double.parse(
                  (calc * processResult.details[findIndex].qty)
                      .toStringAsFixed(2));
              processResult.details[findIndex].extra.add(extra);
            }
          }
          break;
        case 1:
          int findIndex = 0;
          // 1=เพิ่มสินค้า
          // กรณี เป็น New Line ให้เพิ่มบรรทัดใหม่
          ProductBarcodeObjectBoxStruct productBarcode = await global
                  .productBarcodeHelper
                  .selectByBarcodeFirst(logData.barcode) ??
              ProductBarcodeObjectBoxStruct(
                barcode: "",
                names: "",
                name_all: "",
                prices: "",
                unit_code: "",
                unit_names: "",
                new_line: 0,
                color_select: "",
                image_or_color: true,
                color_select_hex: "",
                images_url: "",
                guid_fixed: "",
                item_code: "",
                item_guid: "",
                vat_type: 1,
                descriptions: "",
                item_unit_code: "",
                options_json: "",
                isalacarte: true,
                ordertypes: "",
                product_count: 0,
              );
          // productBarcode.new_line = 1 (ทดสอบขึ้นบรรทัดใหม่ทุกครั้ง)
          productBarcode.new_line = 1;
          // ทดสอบ
          productBarcode.new_line = 0;
          //
          if (productBarcode.barcode.isNotEmpty &&
                  productBarcode.new_line == 1 ||
              global.posScreenNewDataStyle ==
                  global.PosScreenNewDataStyleEnum.newLineOnly) {
            // กรณีสินค้าเป็นประเภทขุึ้นบรรทัดใหม่ทุกครั้ง หรือ ระบบกำหนดให้ขึ้นบรรทัดใหม่ทุกครั้ง
            findIndex = -1;
          } else {
            // กรณีมี Extra ให้เพิ่มบรรทัดใหม่
            var valueOption = jsonDecode(productBarcode.options_json);
            if (valueOption.isNotEmpty) {
              findIndex = -1;
            } else {
              if (global.posScreenNewDataStyle ==
                  global.PosScreenNewDataStyleEnum.addLastLine) {
                findIndex = findByBarCodeAndPrice(
                    logData.barcode, logData.price,
                    lastLineOnly: true);
              } else if (global.posScreenNewDataStyle ==
                  global.PosScreenNewDataStyleEnum.addAllLine) {
                findIndex =
                    findByBarCodeAndPrice(logData.barcode, logData.price);
              }
            }
          }
          if (findIndex == -1) {
            // เพิ่มบรรทัด
            PosProcessDetailModel detail = PosProcessDetailModel(extra: []);
            detail.index = count++;
            detail.barcode = logData.barcode;
            detail.item_code = logData.code;
            detail.item_name = logData.name;
            detail.price = logData.price;
            detail.price_original = logData.price;
            detail.qty = logData.qty;
            detail.total_amount =
                double.parse((logData.price * logData.qty).toStringAsFixed(2));
            detail.unit_code = logData.unit_code;
            detail.unit_name = logData.unit_name;
            detail.guid = logData.guid_auto_fixed;
            detail.image_url = productBarcode.images_url;
            detail.exclude_vat = logData.exclude_vat;
            processResult.details.add(detail);
            result.lineGuid = detail.guid;
          } else {
            // เพิ่มจำนวน
            result.lineGuid = processResult.details[findIndex].guid;
            processResult.details[findIndex].qty =
                (processResult.details[findIndex].qty + logData.qty);
            processCalc(findIndex);
          }
          break;
        case 2:
          // 2=เพิ่มจำนวน + 1
          int findIndex = findByGuid(logData.guid_ref);
          if (findIndex != -1) {
            processResult.details[findIndex].qty =
                (processResult.details[findIndex].qty + 1.0);
            for (int index = 0;
                index < processResult.details[findIndex].extra.length;
                index++) {
              processResult.details[findIndex].extra[index].qty =
                  (processResult.details[findIndex].extra[index].qty + 1.0);
            }
            processCalc(findIndex);
          }
          break;
        case 3:
          // 3=ลดจำนวน - 1
          int findIndex = findByGuid(logData.guid_ref);
          if (findIndex != -1) {
            processResult.details[findIndex].qty =
                (processResult.details[findIndex].qty - 1.0);
            processCalc(findIndex);
          }
          break;
        case 4:
          // 4=แก้จำนวน
          int findIndex = findByGuid(logData.guid_ref);
          if (findIndex != -1) {
            processResult.details[findIndex].qty = logData.qty;
            processCalc(findIndex);
          }
          break;
        case 5:
          // 5=แก้ราคา
          int findIndex = findByGuid(logData.guid_ref);
          if (findIndex != -1) {
            processResult.details[findIndex].price = logData.price;
            processCalc(findIndex);
          }
          break;
        case 8:
          // 8=แก้หมายเหตุ
          int findIndex = findByGuid(logData.guid_ref);
          if (findIndex != -1) {
            processResult.details[findIndex].remark = logData.remark;
            processCalc(findIndex);
          }
          break;
        case 9:
          // 9=ลบรายการ
          int findIndex = findByGuid(logData.guid_ref);
          if (findIndex != -1) {
            processResult.details[findIndex].is_void = true;
            processCalc(findIndex);
          }
          break;
      }
    }
    for (int index = 0; index < valueLog.length; index++) {
      // ประมวลผลส่วนลด
      if (valueLog[index].command_code == 6) {
        PosLogObjectBoxStruct logData = valueLog[index];
        // 6=แก้ส่วนลด
        int findIndex = findByGuid(logData.guid_ref);
        if (findIndex != -1) {
          processResult.details[findIndex].discount_text =
              logData.discount_text;
          double extraTotalAmount = 0;
          for (int extraIndex = 0;
              extraIndex < processResult.details[findIndex].extra.length;
              extraIndex++) {
            extraTotalAmount +=
                processResult.details[findIndex].extra[extraIndex].total_amount;
          }
          double totalAmount = processResult.details[findIndex].qty *
                  processResult.details[findIndex].price +
              extraTotalAmount;

          double discount = processResult.details[findIndex].discount =
              global.calcDiscountFormula(
                  totalAmount: totalAmount,
                  discountText: logData.discount_text);
          serviceLocator<Log>().trace(
              "$extraTotalAmount:$totalAmount:$discount:${logData.discount_text}");
          processResult.details[findIndex].discount = discount;
          processCalc(findIndex);
        }
      }
    }

    // ดึง Promotion
    {
      /*if (processResult.active_line_number != -1) {
        var value = global.promotionTempHelper.select(
            where:
                "barcode_promotion = '${processResult.details[processResult.active_line_number].barcode}'");

        processResult.select_promotion_temp_list = value;
      } else {
        processResult.select_promotion_temp_list.clear();
      }*/
    }
    // ประมวล Promotion
    {
      // อ้างอิงสินค้า รวมยอดจำนวนไว้เพื่อคำนวณ
      List<PromotionProcessByModel> sumByProduct = [];
      for (var _detail in processResult.details) {
        if (_detail.is_void == false) {
          bool found = false;
          for (var _product in sumByProduct) {
            if (_detail.barcode == _product.barcode) {
              // พบ Update ยอดเพิ่ม
              _product.sum_qty += _detail.qty;
              _product.amount -= _detail.total_amount;
              for (var _extra in _detail.extra) {
                _product.extra_amount -= _extra.total_amount;
              }
              found = true;
              break;
            }
          }
          if (found == false) {
            // ไม่พบ เพิ่มใหม่่
            double sumAmount = _detail.total_amount * -1;
            double extraAmount = 0;
            for (var _extra in _detail.extra) {
              extraAmount -= _extra.total_amount;
            }
            sumByProduct.add(PromotionProcessByModel(
                barcode: _detail.barcode,
                sum_qty: _detail.qty,
                amount: sumAmount,
                extra_amount: extraAmount));
          }
        }
      }
      for (var sum in sumByProduct) {
        double qty = sum.sum_qty;
        var value = global.promotionTempHelper.select(
            where:
                "barcode_promotion = '${sum.barcode}' order by limit_qty desc");

        for (var _promotion in value) {
          while (qty >= _promotion.limit_qty) {
            qty -= _promotion.limit_qty;
            double totalAmount0 = (_promotion.include_extra == 1)
                ? ((sum.amount + sum.extra_amount) / sum.sum_qty) *
                    _promotion.limit_qty
                : (sum.amount / sum.sum_qty) * _promotion.limit_qty;
            double calcDiscount = global.calcDiscountFormula(
                totalAmount: totalAmount0,
                discountText: _promotion.discount_text);
            processResult.total_discount_from_promotion += calcDiscount;
            processResult.promotion_list.add(PosProcessPromotionModel(
                promotion_name:
                    "${_promotion.name_1} ${_promotion.promotion_name_1}",
                discount_word: _promotion.discount_text,
                discount: calcDiscount));
            //print("*** " + _promotion.name_1 + " " + _promotion.promotionName_1 + " " + _qty.toString() + " " + _sum.amount.toString());
          }
        }
      }
    }

    // รวม
    double totalPiece = 0;
    double totalItemVatAmount = 0;
    double totalItemExceptVatAmount = 0;
    for (int index = 0; index < processResult.details.length; index++) {
      if (processResult.details[index].is_void == false) {
        totalAmount += processResult.details[index].total_amount;
        if (processResult.details[index].exclude_vat == false) {
          totalItemVatAmount += processResult.details[index].total_amount;
        } else {
          totalItemExceptVatAmount += processResult.details[index].total_amount;
        }
        totalPiece += processResult.details[index].qty;
        for (int extraIndex = 0;
            extraIndex < processResult.details[index].extra.length;
            extraIndex++) {
          if (processResult.details[index].extra[extraIndex].is_void == false) {
            totalAmount +=
                processResult.details[index].extra[extraIndex].total_amount;
          }
        }
      }
    }
    processResult.total_piece = totalPiece;
    processResult.total_item_vat_amount = totalItemVatAmount;
    processResult.total_item_except_amount = totalItemExceptVatAmount;
    processResult.discount_formula = discountFormula;
    processResult.total_discount = global.calcDiscountFormula(
        totalAmount: totalAmount, discountText: discountFormula);
    processResult.vat_rate = 7;
    processResult.total_vat_amount =
        (totalItemVatAmount * processResult.vat_rate) /
            (100 + processResult.vat_rate);
    processResult.total_amount = totalAmount - processResult.total_discount;
    return processResult;
  }
}
