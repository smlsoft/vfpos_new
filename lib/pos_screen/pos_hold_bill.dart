import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;

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
      global.posLogHelper
          .holdCount(global.posHoldProcessResult[index].holdNumber)
          .then((value) {
        setState(() {
          global.posHoldProcessResult[index].logCount = value;
        });
      });
    }
  }

  Widget holdBillContent() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: global.posHoldProcessResult.length,
        itemBuilder: (BuildContext ctx, index) {
          return holdButton(index);
        });
  }

  Widget holdButton(int number) {
    late Color backgroundColor;

    if (global.posHoldProcessResult[number].logCount != 0) {
      backgroundColor = Colors.cyan;
    } else {
      backgroundColor = Colors.green;
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          backgroundColor: (global.posHoldActiveNumber == number)
              ? global.posTheme.secondary
              : backgroundColor),
      onPressed: () async {
        Navigator.pop(context, number);
      },
      child: Column(
        children: [
          Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: Center(child: Text(number.toString()))),
          Expanded(
              child: Center(
            child: Text(
                (global.posHoldProcessResult[number].logCount == 0)
                    ? global.language("blank")
                    : "${global.language('qty')} ${global.posHoldProcessResult[number].logCount}",
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(global.language("pos_hold_bill")),
        backgroundColor: global.posTheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: holdBillContent(),
      ),
    );
  }
}
