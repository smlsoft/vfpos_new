import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'button.dart';

class NumberPadText extends StatefulWidget {
  final Function? onChange;
  final String header;
  final Widget? title;
  final String? unitName;
  final TextAlign textAlign;
  final Color backgroundColor;

  const NumberPadText({Key? key, required this.onChange, this.title, this.unitName, this.textAlign = TextAlign.left, this.backgroundColor = Colors.white, this.header = ""}) : super(key: key);

  @override
  State<NumberPadText> createState() => _NumberPadTextState();
}

class _NumberPadTextState extends State<NumberPadText> {
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
    List<Widget> buttonList = [
      NumPadButton(
        text: '7',
        callBack: () => setValue('7'),
      ),
      NumPadButton(
        text: '8',
        callBack: () => setValue('8'),
      ),
      NumPadButton(
        text: '9',
        callBack: () => setValue('9'),
      ),
      NumPadButton(
        text: '4',
        callBack: () => setValue('4'),
      ),
      NumPadButton(
        text: '5',
        callBack: () => setValue('5'),
      ),
      NumPadButton(
        text: '6',
        callBack: () => setValue('6'),
      ),
      NumPadButton(
        text: '1',
        callBack: () => setValue('1'),
      ),
      NumPadButton(
        text: '2',
        callBack: () => setValue('2'),
      ),
      NumPadButton(
        text: '3',
        callBack: () => setValue('3'),
      ),
      NumPadButton(
        text: '0',
        callBack: () => setValue('0'),
      ),
      NumPadButton(
        text: '.',
        callBack: () => setValue('.'),
      ),
      NumPadButton(
        icon: Icons.backspace,
        callBack: () => backspace(numberStr),
      ),
      NumPadButton(
        text: global.language('cancel'),
        callBack: () {
          Navigator.pop(context);
        },
      ),
      NumPadButton(
        text: global.language('clear'),
        callBack: () {
          setState(() {
            numberStr = '';
          });
        },
      ),
      NumPadButton(
        text: global.language('confirm'),
        callBack: () {
          Navigator.pop(context);
          if (widget.unitName != null) {
            widget.onChange!(numberStr, widget.unitName);
          } else {
            widget.onChange!(numberStr);
          }
        },
      )
    ];

    List<Widget> numPadColumnList = [];
    int itemCount = 0;
    for (int columnIndex = 0; columnIndex < 5; columnIndex++) {
      List<Widget> numPadRowList = [];
      for (int rowIndex = 0; rowIndex < 3; rowIndex++) {
        if (rowIndex != 0) {
          numPadRowList.add(const SizedBox(width: 4));
        }
        numPadRowList.add(Expanded(child: buttonList[itemCount]));
        itemCount++;
      }
      numPadColumnList.add(const SizedBox(height: 4));
      numPadColumnList.add(
        Expanded(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: numPadRowList,
        )),
      );
    }

    return Scaffold(
        body: Container(
            color: widget.backgroundColor,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                if (widget.header != "")
                  Container(
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.only(bottom: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(child: Text(widget.header, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)))),
                if (widget.title != null) Container(child: widget.title),
                Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.all(4),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
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
                    child: Text(numberStr, textAlign: widget.textAlign, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold))),
                Expanded(
                  child: Column(children: numPadColumnList),
                ),
              ],
            )));
  }
}
