import 'package:dedepos/global.dart' as global;
import 'package:flutter/material.dart';
import 'button.dart';

class DiscountPad extends StatefulWidget {
  final Function? onChange;
  final String header;
  final Widget? title;

  const DiscountPad({Key? key, required this.onChange, this.title, this.header = ""}) : super(key: key);

  @override
  State<DiscountPad> createState() => _DiscountPadState();
}

class _DiscountPadState extends State<DiscountPad> {
  String number = '';

  setValue(String val) {
    setState(() {
      number += val;
    });
  }

  saveValueAndClose() {
    setState(() {
      widget.onChange!(number);
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
        body: Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          if (widget.header != "") Text(widget.header, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          if (widget.title != null) Container(padding: const EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 10), child: widget.title),
          Container(
              margin: const EdgeInsets.only(left: 4, right: 4, bottom: 10),
              padding: const EdgeInsets.all(4),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              child: Text(number, style: const TextStyle(fontSize: 32))),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: NumPadButton(
                      margin: 2,
                      text: '7',
                      callBack: () => setValue('7'),
                    )),
                Expanded(
                    flex: 1,
                    child: NumPadButton(
                      margin: 2,
                      text: '8',
                      callBack: () => setValue('8'),
                    )),
                Expanded(
                    flex: 1,
                    child: NumPadButton(
                      margin: 2,
                      text: '9',
                      callBack: () => setValue('9'),
                    )),
              ],
            ),
          ),
          Expanded(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: NumPadButton(
                    text: '4',
                    margin: 2,
                    callBack: () => setValue('4'),
                  )),
              Expanded(
                  flex: 1,
                  child: NumPadButton(
                    text: '5',
                    margin: 2,
                    callBack: () => setValue('5'),
                  )),
              Expanded(
                  flex: 1,
                  child: NumPadButton(
                    text: '6',
                    margin: 2,
                    callBack: () => setValue('6'),
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
                    text: '1',
                    margin: 2,
                    callBack: () => setValue('1'),
                  )),
              Expanded(
                  flex: 1,
                  child: NumPadButton(
                    text: '2',
                    margin: 2,
                    callBack: () => setValue('2'),
                  )),
              Expanded(
                  flex: 1,
                  child: NumPadButton(
                    text: '3',
                    margin: 2,
                    callBack: () => setValue('3'),
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
                    text: '0',
                    margin: 2,
                    callBack: () => setValue('0'),
                  )),
              Expanded(
                  flex: 1,
                  child: NumPadButton(
                    margin: 2,
                    text: '.',
                    callBack: () => setValue('.'),
                  )),
              Expanded(
                  flex: 1,
                  child: NumPadButton(
                    margin: 2,
                    icon: Icons.backspace,
                    callBack: () => backspace(number),
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
                    text: ',',
                    callBack: () => setValue(','),
                  )),
              Expanded(
                  flex: 1,
                  child: NumPadButton(
                    margin: 2,
                    text: '%',
                    callBack: () => setValue('%'),
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
                    text: global.language('cancel'),
                    callBack: () {
                      Navigator.pop(context);
                    },
                  )),
              Expanded(
                  flex: 1,
                  child: NumPadButton(
                    margin: 2,
                    text: global.language('clear'),
                    callBack: () {
                      setState(() {
                        number = '';
                      });
                    },
                  )),
              Expanded(
                  flex: 1,
                  child: NumPadButton(
                    margin: 2,
                    text: global.language('confirm'),
                    callBack: () {
                      Navigator.pop(context);
                      saveValueAndClose();
                    },
                  )),
            ],
          )),
        ],
      ),
    ));
  }
}
