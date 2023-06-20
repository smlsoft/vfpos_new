import 'package:dedepos/db/table_helper.dart';
import 'package:dedepos/model/objectbox/table_struct.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class TableOpenPage extends StatefulWidget {
  @override
  _TableOpenPageState createState() => _TableOpenPageState();
}

class _TableOpenPageState extends State<TableOpenPage> {
  List<String> zoneList = [];
  List<TableObjectBoxStruct> tableList = [];

  @override
  void initState() {
    super.initState();
    tableList = TableHelper().getAll();
    for (var table in tableList) {
      if (table.zone.isEmpty) {
        table.zone = "X";
      }
      if (!zoneList.contains(table.zone) && table.zone != "") {
        zoneList.add(table.zone);
      }
    }
  }

  Widget table(String zone) {
    List<String> tableWhere = [];
    for (var table in tableList.where((element) => element.zone == zone)) {
      tableWhere.add(table.number);
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
              crossAxisCount: context.width ~/ 100),
          itemCount: tableWhere.length,
          itemBuilder: (context, index) {
            return ElevatedButton(
                onPressed: () {}, child: Text(tableWhere[index]));
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("TableOpenPage"),
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
                      child: Text("โซน : " + zone)),
                  table(zone),
                ],
              ),
          ],
        )));
  }
}
