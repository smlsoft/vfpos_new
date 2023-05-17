import 'package:flutter/material.dart';
import 'package:dedepos/widgets/button.dart';

class PosNumPad extends StatefulWidget {
  final Function onChange;
  final Function onSubmit;
  final String header;
  final Widget? title;
  final String? unitName;

  const PosNumPad(
      {Key? key,
      required this.onChange,
      this.title,
      required this.onSubmit,
      this.unitName,
      this.header = ""})
      : super(key: key);

  @override
  PosNumPadState createState() => PosNumPadState();
}

class PosNumPadState extends State<PosNumPad> {
  String number = '';

  void clear() {
    setState(() {
      number = '';
    });
  }

  void passValue(String val) {
    setState(() {
      number = "";
      widget.onSubmit(val);
    });
  }

  void addValue(String val) {
    setState(() {
      number += val;
      widget.onChange(number);
    });
  }

  void backspace() {
    if (number.isNotEmpty) {
      setState(() {
        number = number.split('').sublist(0, number.length - 1).join('');
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.blueAccent)),
                    child: Text(number,
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold))),
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
                                margin: 2,
                                text: '7',
                                callBack: () => addValue('7'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                margin: 2,
                                text: '8',
                                callBack: () => addValue('8'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                margin: 2,
                                text: '9',
                                callBack: () => addValue('9'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                margin: 2,
                                color: Colors.orange,
                                text: 'X',
                                callBack: () => addValue('X'),
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
                                margin: 2,
                                text: '4',
                                callBack: () => addValue('4'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                margin: 2,
                                text: '5',
                                callBack: () => addValue('5'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                margin: 2,
                                text: '6',
                                callBack: () => addValue('6'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                margin: 2,
                                color: Colors.orange,
                                icon: Icons.backspace,
                                callBack: () => backspace(),
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
                                margin: 2,
                                text: '1',
                                callBack: () => addValue('1'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                margin: 2,
                                text: '2',
                                callBack: () => addValue('2'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                margin: 2,
                                text: '3',
                                callBack: () => addValue('3'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                margin: 2,
                                color: Colors.orange,
                                text: 'C',
                                callBack: () => clear(),
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
                                margin: 2,
                                text: '0',
                                callBack: () => addValue('0'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                margin: 2,
                                text: '.',
                                callBack: () => addValue('.'),
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                margin: 2,
                                color: Colors.orange,
                                icon: Icons.check,
                                callBack: () {
                                  widget.onSubmit(number);
                                  setState(() {
                                    number = '';
                                  });
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
