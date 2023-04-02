import 'dart:async';

import 'package:dedepos/pos_screen/pos_connect_client.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PosHoldBill extends StatefulWidget {
  const PosHoldBill({Key? key}) : super(key: key);

  @override
  _PosHoldBillState createState() => _PosHoldBillState();
}

class _PosHoldBillState extends State<PosHoldBill>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    for (int index = 0; index < global.posHoldProcessResult.length; index++) {
      global.posHoldProcessResult[index].countLog =
          global.posLogHelper.holdCount(index);
    }
    global.posHoldProcessResult[global.posHoldActiveNumber].payScreenData =
        global.payScreenData;
  }

  Widget holdBillContent() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: global.posHoldProcessResult.length,
        itemBuilder: (BuildContext ctx, index) {
          return holdButton(index);
        });
  }

  Widget holdButton(int number) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: double.infinity,
      height: 45,
      child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  backgroundColor: (global.posHoldActiveNumber == number)
                      ? global.posTheme.secondary
                      : Colors.green),
              onPressed: () async {
                Navigator.pop(context, number);
              },
              child: Stack(children: [
                SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(
                            (global.posHoldProcessResult[number].countLog == 0)
                                ? global.language("blank")
                                : "${global.language('qty')} ${global.posHoldProcessResult[number].countLog} ${global.language('qty')}",
                            style: const TextStyle(
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.grey,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                                fontSize: 16)),
                      ],
                    )),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                        onPressed: () async {
                          var result = await Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const PosConnectClient(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.insert_link))),
              ]))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(global.language("pos_hold_bill")),
        backgroundColor: global.posTheme.background,
      ),
      body: holdBillContent(),
    );
  }
}
