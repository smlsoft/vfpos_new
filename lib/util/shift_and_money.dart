import 'package:dedepos/core/logger.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/widgets/numpad.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;

/// Mode (0=เปิดกะ+เงินทอน, 1=ปิดกะ+ส่งเงิน, 2=เติมเงินทอน, 3=นำเงินออก)
Widget shiftAndMoneyScreen({required int mode}) {
  TextEditingController remarkTextEditingController = TextEditingController();
  TextStyle textStyle = const TextStyle(
    fontSize: 12,
  );
  String header = "";
  switch (mode) {
    case 0:
      header = "เปิดกะ+เงินทอน";
      break;
    case 1:
      header = "ปิดกะ+ส่งเงิน";
      break;
    case 2:
      header = "เติมเงินทอน";
      break;
    case 3:
      header = "นำเงินออก";
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
                            Text("รหัสพนักงาน", style: textStyle),
                            Text(global.userLoginCode,
                                style: textStyle.copyWith(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text("ชื่อพนักงาน", style: textStyle),
                            Text(global.userLoginName,
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'หมายเหตุ',
                        ),
                      ),
                    if (mode == 2 || mode == 3) const SizedBox(height: 10),
                    Expanded(
                        child: NumberPad(
                            header: "จำนวนเงิน",
                            onChange: (value) {
                              serviceLocator<Log>().debug(value);
                            })),
                  ],
                )))
      ]));
}
