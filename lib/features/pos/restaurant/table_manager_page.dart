import 'package:dedepos/features/shop/shop.dart';
import 'package:slider_captcha/slider_captcha.dart';
import 'package:dedepos/api/clickhouse/clickhouse_api.dart';
import 'package:dedepos/db/table_process_helper.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_print.dart';
import 'package:dedepos/model/objectbox/table_struct.dart';
import 'package:dedepos/services/print_process.dart';
import 'package:dedepos/util/printer.dart' as printer;
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:dedepos/global.dart' as global;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class TableManagerPage extends StatefulWidget {
  final global.TableManagerEnum tableManagerMode;

  const TableManagerPage({Key? key, required this.tableManagerMode})
      : super(key: key);

  @override
  _TableManagerPageState createState() => _TableManagerPageState();
}

class _TableManagerPageState extends State<TableManagerPage> {
  List<String> zoneList = [];
  List<TableProcessObjectBoxStruct> tableList = [];
  int manCount = 0;
  int womanCount = 0;
  int childCount = 0;
  SliderController sliderController = SliderController();

  @override
  void initState() {
    super.initState();
    tableList = TableProcessHelper().getAll();
    for (var table in tableList) {
      if (table.zone.isEmpty) {
        table.zone = "X";
      }
      if (!zoneList.contains(table.zone) && table.zone != "") {
        zoneList.add(table.zone);
      }
    }
  }

  Widget peopleCount(String label, int count, Function(int) callBack) {
    return Row(children: [
      Text(label),
      const Spacer(),
      Container(
          padding: const EdgeInsets.only(left: 50),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            ElevatedButton(
                onPressed: () {
                  if (count > 0) {
                    setState(() {
                      count--;
                      callBack(count);
                    });
                  }
                },
                child: const Icon(Icons.remove)),
            Container(
                width: 50,
                padding: const EdgeInsets.all(10),
                child: Center(child: Text(count.toString()))),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    count++;
                    callBack(count);
                  });
                },
                child: const Icon(Icons.add)),
          ]))
    ]);
  }

  Future<void> tableOpen(int tableIndex) async {
    if (tableList[tableIndex].table_status == 0) {
      // เปิดโต๊ะใหม่
      tableList[tableIndex].table_al_la_crate_mode = false;
    }
    // ถามีการเปิดโต๊ะไปแล้ว แก้ไขจำนวนคน
    manCount = tableList[tableIndex].man_count;
    womanCount = tableList[tableIndex].woman_count;
    childCount = tableList[tableIndex].child_count;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("เปิดโต๊ะ ${tableList[tableIndex].number}"),
            content: StatefulBuilder(
                // You need this, notice the parameters below:
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            (tableList[tableIndex].table_al_la_crate_mode)
                                ? Colors.blue
                                : Colors.grey,
                      ),
                      onPressed: () {
                        if (tableList[tableIndex].table_status == 0) {
                          setState(() {
                            tableList[tableIndex].table_al_la_crate_mode =
                                !tableList[tableIndex].table_al_la_crate_mode;
                          });
                        }
                      },
                      child: (tableList[tableIndex].table_al_la_crate_mode)
                          ? const Row(
                              children: [
                                Text("สั่งแบบอลาคาร์ทได้"),
                                Spacer(),
                                Icon(Icons.check),
                              ],
                            )
                          : const Row(
                              children: [
                                Text("สั่งแบบอลาคาร์ทไม่ได้"),
                                Spacer(),
                                Icon(Icons.cancel),
                              ],
                            )),
                  for (var buffet in global.buffetModeLists)
                    Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  (tableList[tableIndex].buffet_code ==
                                          buffet.code)
                                      ? Colors.blue
                                      : Colors.grey,
                            ),
                            onPressed: () {
                              if (tableList[tableIndex].table_status == 0) {
                                setState(() {
                                  tableList[tableIndex].buffet_code =
                                      buffet.code;
                                });
                              }
                            },
                            child: Row(children: [
                              Text(buffet.names[0]),
                              const Spacer(),
                              (tableList[tableIndex].buffet_code == buffet.code)
                                  ? const Icon(Icons.check)
                                  : const Icon(Icons.cancel),
                            ]))),
                  const SizedBox(height: 10),
                  peopleCount(
                      "ลูกค้าผู้ชาย",
                      manCount,
                      (value) => {
                            setState(() {
                              manCount = value;
                            })
                          }),
                  peopleCount(
                      "ลูกค้าผู้หญิง",
                      womanCount,
                      (value) => {
                            setState(() {
                              womanCount = value;
                            })
                          }),
                  peopleCount(
                      "ลูกค้าเด็ก",
                      childCount,
                      (value) => {
                            setState(() {
                              childCount = value;
                            })
                          })
                ],
              ));
            }),
            actions: [
              TextButton(
                  child: const Text("ยกเลิก"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: const Text("ตกลง"),
                  onPressed: () {
                    if (manCount + womanCount + childCount > 0) {
                      tableList[tableIndex].man_count = manCount;
                      tableList[tableIndex].woman_count = womanCount;
                      tableList[tableIndex].child_count = childCount;
                      if (tableList[tableIndex].table_status == 0) {
                        tableList[tableIndex].table_open_datetime =
                            DateTime.now();
                        tableList[tableIndex].qr_code =
                            Uuid().v4().replaceAll("-", "");
                      }
                      tableList[tableIndex].table_status = 1;
                      TableProcessHelper()
                          .updateByTableNumber(tableList[tableIndex]);
                      clickHouseUpdateTable(tableList[tableIndex]);
                      for (int copy = 0; copy < 2; copy++) {
                        printer.printTableQrCode(
                            tableManagerMode: widget.tableManagerMode,
                            table: tableList[tableIndex],
                            qrCode: "https://dedefoodorder.web.app/?shop=" +
                                global.shopId +
                                "&ticket=" +
                                tableList[tableIndex].qr_code);
                      }
                      Navigator.pop(context);
                    }
                  }),
            ],
          );
        });
  }

  Future<void> tableClose(int tableIndex) async {
    bool confirmDisable = false;

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("ปิดโต๊ะ ${tableList[tableIndex].number}"),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SliderCaptcha(
                    controller: sliderController,
                    image: Image.asset(
                      'assets/images/captcha.png',
                      fit: BoxFit.fitWidth,
                    ),
                    colorBar: Colors.blue,
                    colorCaptChar: Colors.blue,
                    onConfirm: (value) =>
                        Future.delayed(const Duration(seconds: 1)).then(
                      (_) {
                        if (value == false) {
                          sliderController.create();
                        } else {
                          setState(() {
                            confirmDisable = true;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("ยกเลิก")),
                      Spacer(),
                      ElevatedButton(
                          onPressed: (confirmDisable)
                              ? () {
                                  printer.printTableQrCode(
                                    tableManagerMode: widget.tableManagerMode,
                                    table: tableList[tableIndex],
                                  );
                                  tableList[tableIndex].table_status = 2;
                                  TableProcessHelper().updateByTableNumber(
                                      tableList[tableIndex]);
                                  clickHouseUpdateTable(tableList[tableIndex]);
                                  Navigator.pop(context);
                                }
                              : null,
                          child: Text("ปิดโต๊ะ"))
                    ],
                  )
                ],
              ));
            }),
          );
        });
  }

  Widget table(String zone) {
    List<String> tableWhere = [];
    for (var table in tableList.where((element) => element.zone == zone)) {
      if (widget.tableManagerMode == global.TableManagerEnum.openTable ||
          widget.tableManagerMode == global.TableManagerEnum.informationTable) {
        tableWhere.add(table.number);
      } else {
        if (table.table_status == 1) {
          tableWhere.add(table.number);
        }
      }
    }
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        padding: const EdgeInsets.all(4),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              crossAxisCount: context.width ~/ 150),
          itemCount: tableWhere.length,
          itemBuilder: (context, index) {
            var color = Colors.green;
            Widget tableStatus = Container();
            Text tableNumber = Text(tableWhere[index],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.grey,
                        offset: Offset(2.0, 2.0),
                      ),
                    ]));
            int tableListIndex = tableList
                .indexWhere((element) => element.number == tableWhere[index]);
            switch (tableList[tableListIndex].table_status) {
              case 0: // ว่าง
                color = Colors.green;
                break;
              case 1: // มีลูกค้า
                color = Colors.red;
                break;
              case 2: // รอชำระเงิน
                color = Colors.orange;
            }
            if (tableList[tableListIndex].table_status == 1) {
              int maxTimeMinute = 120;
              Duration diff = tableList[tableListIndex]
                  .table_open_datetime
                  .difference(DateTime.now());
              String dateTime = DateFormat('dd-HH:mm')
                  .format(tableList[tableListIndex].table_open_datetime);
              String dateTimeDiff = "";
              if (maxTimeMinute == 0) {
                // สั่งแบบ อาราคัส
                dateTimeDiff = "${diff.inMinutes % 60} นาที";
                if (diff.inHours > 0) {
                  dateTimeDiff = "เวลา : ${diff.inHours} ชม. $dateTimeDiff";
                }
              } else {
                // สั่งแบบ บุฟเฟ่ต์
                DateTime endTime =
                    tableList[tableListIndex].table_open_datetime.add(Duration(
                          minutes: maxTimeMinute,
                        ));
                diff = endTime.difference(DateTime.now());
                dateTime = DateFormat('dd-HH:mm').format(endTime);
                dateTimeDiff = "${diff.inMinutes % 60} นาที";
                if (diff.inHours > 0) {
                  dateTimeDiff =
                      "เหลือเวลา : ${diff.inHours} ชม. $dateTimeDiff";
                }
              }
              int findBuffetIndex = global
                  .findBuffetModeIndex(tableList[tableListIndex].buffet_code);
              tableStatus = Container(
                  padding: const EdgeInsets.all(4),
                  child: Column(children: [
                    Expanded(child: tableNumber),
                    if (tableList[tableListIndex].table_al_la_crate_mode)
                      const Text("สั่งแบบ อาราคัสได้",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    if (findBuffetIndex != -1)
                      Text(
                          "ประเภท : ${global.buffetModeLists[findBuffetIndex].names[0]}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12)),
                    if (tableList[tableListIndex].man_count != 0)
                      Text(
                          "ผู้ชาย : ${global.moneyFormat.format(tableList[tableListIndex].man_count.toDouble())}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12)),
                    if (tableList[index].woman_count != 0)
                      Text(
                          "ผู้หญิง : ${global.moneyFormat.format(tableList[tableListIndex].woman_count.toDouble())}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12)),
                    if (tableList[tableListIndex].child_count != 0)
                      Text(
                          "เด็ก : " +
                              global.moneyFormat.format(
                                  tableList[tableListIndex]
                                      .child_count
                                      .toDouble()),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12)),
                    Text("เวลาเปิดโต๊ะ : $dateTime",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                    Text(dateTimeDiff,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12))
                  ]));
            } else {
              tableStatus = Container(
                  padding: const EdgeInsets.all(4),
                  child: Column(children: [
                    Expanded(child: tableNumber),
                    const Text("ว่าง",
                        style: TextStyle(color: Colors.white, fontSize: 20))
                  ]));
            }
            return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding: const EdgeInsets.all(10),
                    textStyle: const TextStyle(fontSize: 20)),
                child: tableStatus,
                onPressed: () async {
                  switch (widget.tableManagerMode) {
                    case global.TableManagerEnum.openTable:
                      {
                        await tableOpen(tableListIndex);
                      }
                      break;
                    case global.TableManagerEnum.closeTable:
                      {
                        await tableClose(tableListIndex);
                      }
                  }
                  setState(() {});
                });
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    late String title;
    switch (widget.tableManagerMode) {
      case global.TableManagerEnum.openTable:
        title = "table_open";
        break;
      case global.TableManagerEnum.closeTable:
        title = "table_close";
        break;
      case global.TableManagerEnum.moveTable:
        title = "table_move";
        break;
      case global.TableManagerEnum.mergeTable:
        title = "table_merge";
        break;
      case global.TableManagerEnum.splitTable:
        title = "table_split";
        break;
      case global.TableManagerEnum.informationTable:
        title = "table_information";
        break;
      default:
        title = "";
        break;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            for (var zone in zoneList)
              Column(
                children: [
                  Container(
                      width: context.width,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        border: Border.all(color: Colors.blue),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Text(
                        (zone == "X") ? "ไม่ระบุโซน" : "โซน : $zone",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  table(zone),
                ],
              ),
          ],
        )));
  }
}
