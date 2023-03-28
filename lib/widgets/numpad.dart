import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'button.dart';

class Numpad extends StatefulWidget {
  final Function? onChange;
  final String header;
  final Widget? title;
  final String? unitName;

  const Numpad(
      {Key? key,
      required this.onChange,
      this.title,
      this.unitName,
      this.header = ""})
      : super(key: key);

  @override
  _NumpadState createState() => _NumpadState();
}

class _NumpadState extends State<Numpad> {
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
        body: SizedBox(
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
                    margin:
                        const EdgeInsets.only(left: 4, right: 4, bottom: 10),
                    padding: const EdgeInsets.all(4),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
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
                              child: NumpadButton(
                                text: '7',
                                callBack: () => setValue('7'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumpadButton(
                                text: '8',
                                callBack: () => setValue('8'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumpadButton(
                                text: '9',
                                callBack: () => setValue('9'),
                              )),
                        ],
                      )),
                      Expanded(
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: NumpadButton(
                                text: '4',
                                callBack: () => setValue('4'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumpadButton(
                                text: '5',
                                callBack: () => setValue('5'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumpadButton(
                                text: '6',
                                callBack: () => setValue('6'),
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
                              child: NumpadButton(
                                text: '1',
                                callBack: () => setValue('1'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumpadButton(
                                text: '2',
                                callBack: () => setValue('2'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumpadButton(
                                text: '3',
                                callBack: () => setValue('3'),
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
                              child: NumpadButton(
                                text: '0',
                                callBack: () => setValue('0'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumpadButton(
                                text: '.',
                                callBack: () => setValue('.'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumpadButton(
                                icon: Icons.backspace,
                                callBack: () => backspace(number),
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
                              child: NumpadButton(
                                text: global.language('cancel'),
                                callBack: () {
                                  Navigator.pop(context);
                                },
                              )),
                          Expanded(
                              flex: 1,
                              child: NumpadButton(
                                text: global.language('clear'),
                                callBack: () {
                                  setState(() {
                                    number = '';
                                  });
                                },
                              )),
                          Expanded(
                              flex: 1,
                              child: NumpadButton(
                                text: global.language('confirm'),
                                callBack: () {
                                  Navigator.pop(context);
                                  if (widget.unitName != null) {
                                    widget.onChange!(
                                        double.tryParse(number) ?? 0.0,
                                        widget.unitName);
                                  } else {
                                    widget.onChange!(
                                        double.tryParse(number) ?? 0.0);
                                  }
                                },
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
