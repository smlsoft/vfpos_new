import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'button.dart';

class NumberPad extends StatefulWidget {
  final Function? onChange;
  final String header;
  final Widget? title;
  final String? unitName;

  const NumberPad(
      {Key? key,
      required this.onChange,
      this.title,
      this.unitName,
      this.header = ""})
      : super(key: key);

  @override
  _NumberPadState createState() => _NumberPadState();
}

class _NumberPadState extends State<NumberPad> {
  String numberStr = '';

  setValue(String val) {
    setState(() {
      numberStr += val;
    });
  }

  backspace(String text) {
    if (text.isNotEmpty) {
      setState(() {
        numberStr = text.split('').sublist(0, text.length - 1).join('');
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
                    margin: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                    padding: const EdgeInsets.all(4),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                        border: Border.all(color: Colors.blueAccent)),
                    child:
                        Text(numberStr, style: const TextStyle(fontSize: 32))),
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
                                icon: Icons.backspace,
                                callBack: () => backspace(numberStr),
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
                                text: global.language('cancel'),
                                callBack: () {
                                  Navigator.pop(context);
                                },
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                text: global.language('clear'),
                                callBack: () {
                                  setState(() {
                                    numberStr = '';
                                  });
                                },
                              )),
                          Expanded(
                              flex: 1,
                              child: NumPadButton(
                                text: global.language('confirm'),
                                callBack: () {
                                  Navigator.pop(context);
                                  if (widget.unitName != null) {
                                    widget.onChange!(
                                        numberStr, widget.unitName);
                                  } else {
                                    widget.onChange!(numberStr);
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
