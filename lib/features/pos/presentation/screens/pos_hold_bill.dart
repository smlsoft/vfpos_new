import 'package:dedepos/db/table_process_helper.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/objectbox/table_struct.dart';
import 'package:dedepos/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:intl/intl.dart';

class PosHoldBill extends StatefulWidget {
  final int holdType;

  const PosHoldBill({Key? key, required this.holdType}) : super(key: key);

  @override
  State<PosHoldBill> createState() => _PosHoldBillState();
}

class _PosHoldBillState extends State<PosHoldBill>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    for (int index = 0; index < global.posHoldProcessResult.length; index++) {
      global.posLogHelper
          .holdCount(global.posHoldProcessResult[index].code)
          .then((value) {
        setState(() {
          global.posHoldProcessResult[index].logCount = value;
        });
      });
    }
  }

  Widget holdBillContent() {
    List<PosHoldProcessModel> holds = [];
    if (widget.holdType == 1) {
      // ระบบ POS
      for (int index = 0; index < global.posHoldProcessResult.length; index++) {
        if (global.posHoldProcessResult[index].holdType == widget.holdType) {
          holds.add(global.posHoldProcessResult[index]);
        }
      }
    }
    if (widget.holdType == 2) {
      // ระบบร้านอาหาร
      List<TableProcessObjectBoxStruct> tableInfo =
          TableProcessHelper().getAll();
      for (var table in tableInfo) {
        if (table.table_status == 2) {
          PosHoldProcessModel hold = PosHoldProcessModel(
              code: "T-${table.number}", tableNumber: table.number);
          hold.holdType = 2;
          hold.isDelivery = table.is_delivery;
          hold.deliveryNumber = table.delivery_number;
          holds.add(hold);
        }
      }
    }

    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: holds.length,
        itemBuilder: (BuildContext ctx, index) {
          return holdButton(holds[index]);
        });
  }

  Widget holdButton(PosHoldProcessModel hold) {
    late Color backgroundColor;
    print("hold : ${hold.code} : ${hold.logCount}");
    {
      // test
      List<TableProcessObjectBoxStruct> tableInfo = global.objectBoxStore
          .box<TableProcessObjectBoxStruct>()
          .query()
          .build()
          .find();
      for (var table in tableInfo) {
        print("table : ${table.number} : ${table.table_status}");
      }
    }
    if (global
            .posHoldProcessResult[
                global.findPosHoldProcessResultIndex(hold.code)]
            .logCount !=
        0) {
      backgroundColor = Colors.cyan;
    } else {
      backgroundColor = Colors.green;
    }
    Widget tableStatus = Container();
    if (widget.holdType == 1) {
      // POS
      int holdIndex = global.findPosHoldProcessResultIndex(hold.code);
      tableStatus = Text(
          (global.posHoldProcessResult[holdIndex].logCount == 0)
              ? global.language("blank")
              : "${global.language('qty')} ${global.posHoldProcessResult[holdIndex].logCount} รายการ",
          style: const TextStyle(color: Colors.white, fontSize: 16));
    }
    if (widget.holdType == 2) {
      // ร้านอาหาร
      TableProcessObjectBoxStruct? tableInfo = global.objectBoxStore
          .box<TableProcessObjectBoxStruct>()
          .query(TableProcessObjectBoxStruct_.number
              .equals(hold.code.replaceAll("T-", "")))
          .build()
          .findFirst();
      String orderType = "";
      if (tableInfo != null) {
        if (tableInfo.table_al_la_crate_mode) {
          orderType = "อาราคัส";
        } else {
          int findBuffetIndex =
              global.findBuffetModeIndex(tableInfo.buffet_code);
          if (findBuffetIndex != -1) {
            orderType =
                orderType = global.buffetModeLists[findBuffetIndex].names[0];
          }
        }
      }
      tableStatus = (tableInfo != null)
          ? Container(
              padding: const EdgeInsets.all(4),
              child: Column(children: [
                if (tableInfo.is_delivery)
                  const Text("สั่งกลับบ้าน",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                Text("ประเภท : $orderType",
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
                if (tableInfo.man_count != 0)
                  Text(
                      "ผู้ชาย : ${global.moneyFormat.format(tableInfo.man_count.toDouble())}",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                if (tableInfo.woman_count != 0)
                  Text(
                      "ผู้หญิง : ${global.moneyFormat.format(tableInfo.woman_count.toDouble())}",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                if (tableInfo.child_count != 0)
                  Text(
                      "เด็ก : ${global.moneyFormat.format(tableInfo.child_count.toDouble())}",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                Text(
                    "เวลาเปิดโต๊ะ : ${DateFormat('dd-HH:mm').format(tableInfo.table_open_datetime)}",
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ]))
          : Container();
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          backgroundColor: (global.posHoldActiveCode == hold.code)
              ? global.posTheme.secondary
              : backgroundColor),
      onPressed: () async {
        Navigator.pop(context, hold);
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
              child: Center(
                  child: Text((hold.isDelivery)
                      ? hold.deliveryNumber
                      : (hold.code.contains("T-"))
                          ? "โต๊ะ : ${hold.code.replaceAll("T-", "")}"
                          : "พักบิล : ${hold.code}"))),
          Expanded(
              child: Center(
            child: tableStatus,
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((widget.holdType == 1)
            ? global.language("pos_hold_bill")
            : global.language("pos_hold_table")),
        backgroundColor: global.posTheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: holdBillContent(),
      ),
    );
  }
}
