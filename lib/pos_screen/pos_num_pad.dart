import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/widgets/button.dart';

class PosNumPad extends StatefulWidget {
  final Function? onChange;
  final String header;
  final Widget? title;
  final String? unitName;

  const PosNumPad(
      {Key? key,
      required this.onChange,
      this.title,
      this.unitName,
      this.header = ""})
      : super(key: key);

  @override
  _PosNumPadState createState() => _PosNumPadState();
}

class _PosNumPadState extends State<PosNumPad> {
  String number = '';

  setValue(String val) {
    setState(() {
      number += val;
    });
  }

  backspace(String text) {
    if (text.isNotEmpty) {
      setState(() {
        number = text.split('').sublist(0, text.length - 1).join('');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.blueAccent)),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                if (widget.header != "")
                  Text(widget.header,
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold)),
                if (widget.title != null)
                  Container(
                      padding: const EdgeInsets.only(
                          left: 4, right: 4, top: 10, bottom: 10),
                      child: widget.title),
                Container(
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.blueAccent)),
                    child: Text(number, style: const TextStyle(fontSize: 32))),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                text: '7',
                                callBack: () => setValue('7'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                text: '8',
                                callBack: () => setValue('8'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                text: '9',
                                callBack: () => setValue('9'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                color: Colors.orange,
                                text: 'X',
                                callBack: () => setValue('X'),
                              )),
                        ],
                      )),
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                text: '4',
                                callBack: () => setValue('4'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                text: '5',
                                callBack: () => setValue('5'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                text: '6',
                                callBack: () => setValue('6'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                color: Colors.orange,
                                text: '-',
                                callBack: () => setValue('-'),
                              )),
                        ],
                      )),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                text: '1',
                                callBack: () => setValue('1'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                text: '2',
                                callBack: () => setValue('2'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                text: '3',
                                callBack: () => setValue('3'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                color: Colors.orange,
                                text: '+',
                                callBack: () => setValue('+'),
                              )),
                        ],
                      )),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: NumPadButton(
                                text: '0',
                                callBack: () => setValue('0'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                text: '.',
                                callBack: () => setValue('.'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                color: Colors.orange,
                                text: '=',
                                callBack: () => setValue('='),
                              )),
                        ],
                      )),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                text: global.language('clear'),
                                color: Colors.red,
                                callBack: () {
                                  setState(() {
                                    number = '';
                                  });
                                },
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                icon: Icons.backspace,
                                color: Colors.orange,
                                callBack: () => backspace(number),
                              )),
                        ],
                      )),
                    ],
                  ),
                )
              ],
            )));
  }
}
