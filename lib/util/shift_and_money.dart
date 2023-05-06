import 'package:dedepos/widgets/numpad.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;

Widget shiftAndMoneyScreen() {
  TextStyle textStyle = const TextStyle(
    fontSize: 18,
  );
  return Container(
      padding: const EdgeInsets.all(10),
      width: 400,
      height: 500,
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
                      style: textStyle.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              TableRow(
                children: [
                  Text("ชื่อพนักงาน", style: textStyle),
                  Text(global.userLoginName,
                      style: textStyle.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          SizedBox(height: 25),
          Expanded(
              child: NumberPad(
                  header: "จำนวนเงินทอนเริ่มต้น",
                  onChange: (value) {
                    print(value);
                  })),
        ],
      ));
}
