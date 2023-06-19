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
  String connectCode =
      global.apiShopID + "/" + global.ipAddress + "/" + global.connectGuid;
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
        title: const Text('Connect Staff Client Page'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
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
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(children: [
                      Text(
                        "Staff Scan QR Code to Connect",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                          child: Container(
                              child: Center(
                                  child: QrImageView(
                        size: 200,
                        backgroundColor: Colors.white,
                        data: connectCode,
                        version: QrVersions.auto,
                      )))),
                      Text(
                        "IP Address : " + global.ipAddress,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Connect Code : " + connectSecureCode,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ])))
          ],
        ),
      ),
    )));
  }
}
