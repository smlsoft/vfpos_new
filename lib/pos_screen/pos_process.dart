import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/pos_log_struct.dart';
import 'package:dedepos/model/json/pos_process_struct.dart';
import 'package:dedepos/api/sync/model/promotion_struct.dart';
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';

class PosProcess {
  final PosProcessStruct processResult = PosProcessStruct(
      details: [], select_promotion_temp_list: [], promotion_list: []);

  void sumGroupCount(PosProcessStruct result) {
    for (var product in global.productListByCategory) {
      product.product_count = 0;
      for (var transDetail in result.details) {
        if (product.barcode == transDetail.barcode &&
            transDetail.is_void == false) {
          product.product_count += transDetail.qty;
        }
      }
    }
    // Group
    for (var group in global.productCategoryList) {
      group.product_count = 0;
    }
    for (var transDetail in result.details) {
      for (var group in global.productCategoryList) {
        if (transDetail.category_guid == group.guid_fixed &&
            transDetail.is_void == false) {
          group.product_count = group.product_count + transDetail.qty;
        }
      }
    }
    // Group Child List
    for (var group in global.productCategoryChildList) {
      group.product_count = 0;
    }
    for (var transDetail in result.details) {
      for (var group in global.productCategoryChildList) {
        if (transDetail.category_guid == group.guid_fixed &&
            transDetail.is_void == false) {
          group.product_count = group.product_count + transDetail.qty;
        }
      }
    }
    // Group Selected
    for (var group in global.productCategoryCodeSelected) {
      group.product_count = 0;
    }
    for (var transDetail in result.details) {
      for (var group in global.productCategoryCodeSelected) {
        if (transDetail.category_guid == group.guid_fixed &&
            transDetail.is_void == false) {
          group.product_count = group.product_count + transDetail.qty;
        }
      }
    }
  }

  int findByBarCodeAndPrice(String barcode, double price) {
    int result = -1;
    for (int index = 0; index < processResult.details.length; index++) {
      if (barcode == processResult.details[index].barcode &&
          price == processResult.details[index].price &&
          processResult.details[index].is_void == false) {
        result = index;
        break;
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

  Future<PosProcessStruct> process() async {
    print("****** Process : " + DateTime.now().toString());
    double totalAmount = 0;
    // ค้นหา Barcode
    var valueLog = global.posLogHelper.selectByHoldNumberIsVoidSuccess(
        holdNumber: global.posHoldNumber, isVoid: 0, success: 0);
    /*print('Total Log ' + _valueLog.length.toString());
    for (int _index = _valueLog.length - 1; _index > 0; _index--) {
      switch (_valueLog[_index].command_code) {
        case 100:
          // ลบ Radio เอาตัวสุดท้ายตัวเดียว
          for (int _findIndex = _index - 1; _findIndex > 0; _findIndex--) {
            if (_valueLog[_findIndex].command_code ==
                _valueLog[_index].command_code) {
              if (_valueLog[_findIndex].group == _valueLog[_index].group &&
                  _valueLog[_findIndex].guid_fixed ==
                      _valueLog[_index].guid_fixed) {
                _valueLog[_findIndex].is_void = 1;
              }
            }
          }
          break;
        case 101:
          // ลบ Check Box เอาตัวสุดท้ายตัวเดียว
          for (int _findIndex = _index - 1; _findIndex > 0; _findIndex--) {
            if (_valueLog[_findIndex].command_code ==
                _valueLog[_index].command_code) {
              if (_valueLog[_index].group == _valueLog[_findIndex].group &&
                  _valueLog[_index].code == _valueLog[_findIndex].code &&
                  _valueLog[_index].guid_fixed ==
                      _valueLog[_findIndex].guid_fixed) {
                _valueLog[_findIndex].is_void = 1;
              }
            }
          }
          break;
      }
    }*/

    int count = 0;
    for (int index = 0; index < valueLog.length; index++) {
      // ประมวลผล จำนวน,ราคา
      PosLogObjectBoxStruct logData = valueLog[index];
      PosProcessDetailStruct detail = PosProcessDetailStruct(extra: []);
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
      switch (logData.command_code) {
        case 101:
          // 101=Check Box Extra
          if (logData.is_void == 0) {
            int findIndex = findByGuid(logData.guid_ref);
            if (findIndex != -1) {
              // เพิ่มบรรทัด (Extra)
              PosProcessDetailExtraStruct extra = PosProcessDetailExtraStruct();
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
              processResult.active_line_number = findIndex;
            }
          }
          break;
        case 1:
          int findIndex = 0;
          // 1=เพิ่มสินค้า
          // กรณี เป็น New Line ให้เพิ่มบรรทัดใหม่
          ProductBarcodeObjectBoxStruct productBarcode = global
                  .productBarcodeHelper
                  .selectByBarcodeFirst(logData.barcode) ??
              ProductBarcodeObjectBoxStruct(
                barcode: "",
                group_count: 0,
                names: [],
                name_all: "",
                prices: [],
                unit_code: "",
                unit_names: [],
                new_line: 0,
                group_code: "",
                parent_group_guid: "",
                category_index: 0,
                color_select: "",
                image_or_color: true,
                color_select_hex: "",
                images_url: "",
                guid_fixed: "",
                item_code: "",
                item_guid: "",
                descriptions: [],
                item_unit_code: "",
                options_json: "",
                product_count: 0,
              );
          // productBarcode.new_line = 1 (ทดสอบขึ้นบรรทัดใหม่ทุกครั้ง)
          productBarcode.new_line = 1;
          //
          if (productBarcode.barcode.isNotEmpty &&
              productBarcode.new_line == 1) {
            findIndex = -1;
          } else {
            // กรณีมี Extra ให้เพิ่มบรรทัดใหม่
            var valueOption = productBarcode.options();
            if (valueOption.isNotEmpty) {
              findIndex = -1;
            } else {
              findIndex = findByBarCodeAndPrice(logData.barcode, logData.price);
            }
          }
          if (findIndex == -1) {
            // เพิ่มบรรทัด
            detail.index = count++;
            detail.barcode = logData.barcode;
            detail.item_code = logData.code;
            detail.item_name = logData.name;
            detail.price = logData.price;
            detail.qty = logData.qty;
            detail.total_amount =
                double.parse((logData.price * logData.qty).toStringAsFixed(2));
            detail.unit_code = logData.unit_code;
            detail.unit_name = logData.unit_name;
            detail.guid = logData.guid_auto_fixed;
            detail.image_url = productBarcode.images_url;
            detail.category_guid = productBarcode.group_code;
            processResult.details.add(detail);
            processResult.active_line_number = processResult.details.length - 1;
          } else {
            // เพิ่มจำนวน
            processResult.details[findIndex].qty =
                (processResult.details[findIndex].qty + logData.qty);
            processCalc(findIndex);
            processResult.active_line_number = findIndex;
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
            processResult.active_line_number = findIndex;
          }
          break;
        case 3:
          // 3=ลดจำนวน - 1
          int findIndex = findByGuid(logData.guid_ref);
          if (findIndex != -1) {
            processResult.details[findIndex].qty =
                (processResult.details[findIndex].qty - 1.0);
            processCalc(findIndex);
            processResult.active_line_number = findIndex;
          }
          break;
        case 4:
          // 4=แก้จำนวน
          int findIndex = findByGuid(logData.guid_ref);
          if (findIndex != -1) {
            processResult.details[findIndex].qty = logData.qty;
            processCalc(findIndex);
            processResult.active_line_number = findIndex;
          }
          break;
        case 5:
          // 5=แก้ราคา
          int findIndex = findByGuid(logData.guid_ref);
          if (findIndex != -1) {
            processResult.details[findIndex].price = logData.price;
            processCalc(findIndex);
            processResult.active_line_number = findIndex;
          }
          break;
        case 8:
          // 8=แก้หมายเหตุ
          int findIndex = findByGuid(logData.guid_ref);
          if (findIndex != -1) {
            processResult.details[findIndex].remark = logData.remark;
            processCalc(findIndex);
            processResult.active_line_number = findIndex;
          }
          break;
        case 9:
          // 9=ลบรายการ
          int findIndex = findByGuid(logData.guid_ref);
          if (findIndex != -1) {
            processResult.details[findIndex].is_void = true;
            processCalc(findIndex);
            processResult.active_line_number = findIndex;
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
          processResult.details[findIndex].discount_text = logData.discountText;
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
                  totalAmount: totalAmount, discountText: logData.discountText);
          print(extraTotalAmount.toString() +
              ":" +
              totalAmount.toString() +
              ":" +
              discount.toString() +
              ":" +
              logData.discountText);
          processResult.details[findIndex].discount = discount;
          processCalc(findIndex);
        }
      }
    }

    // ดึง Promotion
    {
      if (processResult.active_line_number != -1) {
        var value = global.promotionTempHelper.select(
            where:
                "barcode_promotion = '${processResult.details[processResult.active_line_number].barcode}'");

        processResult.select_promotion_temp_list = value;
      } else {
        processResult.select_promotion_temp_list.clear();
      }
    }
    // ประมวล Promotion
    {
      // อ้างอิงสินค้า รวมยอดจำนวนไว้เพื่อคำนวณ
      List<PromotionProcessByProduct> sumByProduct = [];
      for (var _detail in processResult.details) {
        if (_detail.is_void == false) {
          bool _found = false;
          for (var _product in sumByProduct) {
            if (_detail.barcode == _product.barcode) {
              // พบ Update ยอดเพิ่ม
              _product.sum_qty += _detail.qty;
              _product.amount -= _detail.total_amount;
              for (var _extra in _detail.extra) {
                _product.extra_amount -= _extra.total_amount;
              }
              _found = true;
              break;
            }
          }
          if (_found == false) {
            // ไม่พบ เพิ่มใหม่่
            double _sumAmount = _detail.total_amount * -1;
            double _extraAmount = 0;
            for (var _extra in _detail.extra) {
              _extraAmount -= _extra.total_amount;
            }
            sumByProduct.add(PromotionProcessByProduct(
                barcode: _detail.barcode,
                sum_qty: _detail.qty,
                amount: _sumAmount,
                extra_amount: _extraAmount));
          }
        }
      }
      for (var sum in sumByProduct) {
        double qty = sum.sum_qty;
        var value = global.promotionTempHelper.select(
            where: "barcode_promotion = '" +
                sum.barcode +
                "' order by limit_qty desc");

        for (var _promotion in value) {
          while (qty >= _promotion.limit_qty) {
            qty -= _promotion.limit_qty;
            double _totalAmount = (_promotion.include_extra == 1)
                ? ((sum.amount + sum.extra_amount) / sum.sum_qty) *
                    _promotion.limit_qty
                : (sum.amount / sum.sum_qty) * _promotion.limit_qty;
            double _calcDiscount = global.calcDiscountFormula(
                totalAmount: _totalAmount,
                discountText: _promotion.discount_text);
            processResult.total_discount_from_promotion += _calcDiscount;
            processResult.promotion_list.add(PosProcessPromotionStruct(
                promotion_name:
                    _promotion.name_1 + " " + _promotion.promotion_name_1,
                discount_word: _promotion.discount_text,
                discount: _calcDiscount));
            //print("*** " + _promotion.name_1 + " " + _promotion.promotionName_1 + " " + _qty.toString() + " " + _sum.amount.toString());
          }
        }
      }
    }

    // รวม
    double totalPiece = 0;
    for (int index = 0; index < processResult.details.length; index++) {
      if (processResult.details[index].is_void == false) {
        totalAmount += processResult.details[index].total_amount;
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
    processResult.total_amount = totalAmount;
    processResult.customer_code = global.customerCode;
    processResult.customer_name = global.customerName;
    processResult.customer_phone = global.customerPhone;

    print("------ Process : " + DateTime.now().toString());
    return processResult;
  }
}