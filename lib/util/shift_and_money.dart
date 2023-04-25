import 'package:dedepos/widgets/numpad.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;

class ShiftAndMoneyScreen extends StatefulWidget {
  const ShiftAndMoneyScreen({super.key});

  @override
  _ShiftAndMoneyScreenState createState() => _ShiftAndMoneyScreenState();
}

class _ShiftAndMoneyScreenState extends State<ShiftAndMoneyScreen> {
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(
      fontSize: 24,
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Shift and Money")),
        body: Center(
          child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              padding: EdgeInsets.all(10),
              width: 400,
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
                  SizedBox(height: 25),
                  Expanded(
                      child: NumberPad(
                          header: "จำนวนเงินทอนเริ่มต้น",
                          onChange: (value) {
                            print(value);
                          })),
                ],
              )),
        ),
      ),
    );
  }
}
