import 'package:dedepos/global.dart' as global;
import 'package:dedepos/widgets/numpad.dart';
import 'package:dedepos/widgets/pin_numpad.dart';
import 'package:flutter/material.dart';

class PosClient extends StatefulWidget {
  const PosClient({Key? key}) : super(key: key);

  @override
  _PosClientState createState() => _PosClientState();
}

class _PosClientState extends State<PosClient> {
  bool connectTerminalSuccess = false;

  @override
  Widget build(BuildContext context) {
    Widget screen = Container();
    if (connectTerminalSuccess == false) {
      screen = Container(
        margin: EdgeInsets.all(20),
        child: PinNumberPad(
          header: global.language("pos_pin_connect_terminal"),
          onChange: () {},
        ),
      );
    } else {
      screen = Column(
        children: [
          Container(
              margin: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.cyan.shade100,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Column(children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.all(10),
                  child: Center(child: Text('select_pos_client_number')),
                ),
                Wrap(children: [
                  for (int i = 0; i < global.posHoldMax; i++)
                    Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(i.toString()),
                        ))
                ])
              ]))),
        ],
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(resizeToAvoidBottomInset: false, body: screen),
      ),
    );
  }
}
