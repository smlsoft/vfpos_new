import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;

class HoldBill extends StatefulWidget {
  const HoldBill({Key? key}) : super(key: key);

  @override
  _HoldBillState createState() => _HoldBillState();
}

class _HoldBillState extends State<HoldBill> with TickerProviderStateMixin {
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
      margin: const EdgeInsets.all(2.5),
      height: 45,
      child: SizedBox(
          child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: (global.posHoldActiveNumber == number)
                ? global.posTheme.secondary
                : Colors.green),
        onPressed: () async {
          Navigator.pop(context, number);
        },
        child: Column(
          children: [
            Text(
                (global.posHoldProcessResult[number].countLog == 0)
                    ? "blank"
                    : global.posHoldProcessResult[number].countLog.toString() +
                        " " +
                        'รายการ',
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
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("พักบิล"),
      ),
      body: holdBillContent(),
    );
  }
}
