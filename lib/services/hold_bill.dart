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
    for (int _index = 0; _index < global.posHoldList.length; _index++) {
      global.posHoldList[_index].countLog =
          global.posLogHelper.holdCount(_index);
    }
    global.posHoldList[global.posHoldNumber].payScreenData =
        global.payScreenData;
  }

  Widget holdBillContent() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: global.posHoldList.length,
        itemBuilder: (BuildContext ctx, index) {
          return holdButton(index);
        });
  }

  Widget holdButton(int number) {
    return Container(
      margin: EdgeInsets.all(2.5),
      height: 45,
      child: SizedBox(
          child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: (global.posHoldNumber == number)
                ? global.posTheme.secondary
                : Colors.green),
        onPressed: () async {
          Navigator.pop(context, number);
        },
        child: Column(
          children: [
            Text(
                (global.posHoldList[number].countLog == 0)
                    ? "blank"
                    : global.posHoldList[number].countLog.toString() +
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