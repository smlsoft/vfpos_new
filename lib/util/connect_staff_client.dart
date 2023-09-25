import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:dedepos/global.dart' as global;
import 'package:uuid/uuid.dart';

class ConnectStaffClientPage extends StatefulWidget {
  const ConnectStaffClientPage({Key? key}) : super(key: key);

  @override
  _ConnectStaffClientPageState createState() => _ConnectStaffClientPageState();
}

class _ConnectStaffClientPageState extends State<ConnectStaffClientPage> {
  late Timer timer;
  String connectCode = "${global.apiShopID}/${global.ipAddress}/${global.connectGuid}";
  late String connectSecureCode;

  @override
  void initState() {
    super.initState();
    genGuid();
    connectSecureCode = (Random().nextInt(9000) + 1000).toString();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    global.connectGuid = "";
    timer.cancel();
  }

  void genGuid() {
    global.connectGuid = const Uuid().v4();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Scaffold(
      appBar: AppBar(
        title: const Text('เชื่อมต่อเครื่องลูก'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      itemCount: global.staffClientList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(global.staffClientList[index].name),
                          onTap: () {},
                        );
                      },
                    ))),
            Expanded(
                flex: 1,
                child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(children: [
                      const Text(
                        "เครื่องลูกที่มีกล้องสามารถ Scan Qr Code ได้",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                          child: Center(
                              child: QrImageView(
                        size: 200,
                        backgroundColor: Colors.white,
                        data: connectCode,
                        version: QrVersions.auto,
                      ))),
                      const Text("เครื่องลูกที่ไม่มีกล้อง สามารถเชื่อมต่อด้วย IP Address"),
                      Text(
                        "IP Address : ${global.ipAddress}",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "รหัสสำหรับเชื่อมต่อ : $connectSecureCode",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ])))
          ],
        ),
      ),
    )));
  }
}
