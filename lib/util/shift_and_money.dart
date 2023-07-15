import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/db/shift_helper.dart';
import 'package:dedepos/model/objectbox/shift_struct.dart';
import 'package:dedepos/util/printer.dart';
import 'package:dedepos/widgets/numpad.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:uuid/uuid.dart';

/// Mode (1=เปิดกะ+เงินทอน, 2=ปิดกะ+ส่งเงิน, 3=เติมเงินทอน, 4=นำเงินออก)
Widget shiftAndMoneyScreen({required int mode}) {
  TextEditingController remarkTextEditingController = TextEditingController();
  TextStyle textStyle = const TextStyle(
    fontSize: 12,
  );
  String header = "";
  switch (mode) {
    case 0:
      header = global
          .language("open_the_cash_register_and_change"); // "เปิดกะ+เงินทอน";
      break;
    case 1:
      header = global
          .language("close_the_shift"); // "ปิดกะ+ส่งเงิน";
      break;
    case 2:
      header = global.language("replenish_change"); // "เติมเงินทอน";
      break;
    case 3:
      header = global.language("take_out_money"); // "นำเงินออก";
      break;
  }
  return Container(
      width: 300,
      height: 500,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
          ),
        ],
      ),
      child: Column(children: [
        Container(
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 2,
                ),
              ],
            ),
            child: Center(
                child: Text(header,
                    style: textStyle.copyWith(
                        shadows: <Shadow>[
                          const Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 3.0,
                            color: Colors.grey,
                          )
                        ],
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black)))),
        Expanded(
            child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                      },
                      children: [
                        TableRow(
                          children: [
                            Text(global.language("employee_code"),
                                style: textStyle),
                            Text(global.userLogin!.code,
                                style: textStyle.copyWith(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(global.language("employee_name"),
                                style: textStyle),
                            Text(global.userLogin!.name,
                                style: textStyle.copyWith(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (mode == 2 || mode == 3)
                      TextField(
                        controller: remarkTextEditingController,
                        style: textStyle,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: global.language("remark"),
                        ),
                      ),
                    if (mode == 2 || mode == 3) const SizedBox(height: 10),
                    Expanded(
                        child: NumberPad(
                            header: global.language("amount_of_money"),
                            onChange: (value) {
                              double amount = double.tryParse(value) ?? 0;
                              // กด ตกลง
                              if (amount != 0) {
                                String guid = Uuid().v4();
                                ShiftObjectBoxStruct data =
                                    ShiftObjectBoxStruct(
                                  guidfixed: guid,
                                  doctype: mode,
                                  docdate: DateTime.now(),
                                  remark: remarkTextEditingController.text,
                                  usercode: global.userLogin!.code,
                                  username: global.userLogin!.name,
                                  amount: amount,
                                  creditcard: 1,
                                  promptpay: 2,
                                  transfer: 3,
                                  cheque: 4,
                                  coupon: 5,
                                );
                                ShiftHelper().insert(data);
                                shiftAndMoneyPrint(guid);
                              }
                            })),
                  ],
                )))
      ]));
}
