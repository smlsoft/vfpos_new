import 'package:flutter/material.dart';

class PayButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String label;
  final Widget child;
  final Color? primary;
  final Color border;
  final double? height;
  const PayButton({Key? key, required this.onPressed, required this.label, required this.child, this.primary = Colors.blueGrey, this.border = Colors.cyan, this.height = 40})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (Material(
        color: (primary == null) ? Theme.of(context).primaryColor : primary,
        child: InkWell(
          /*style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.only(left: 8, right: 8),
        primary: primary,
        onPrimary: onPrimary,
      ),*/
          //onPressed: () => {global.playSound(global.SoundEnum.buttonTing), onPressed()},
          onTap: () => {onPressed()},
          child: Container(
              decoration: BoxDecoration(border: Border.all(color: border)),
              height: height,
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                  child,
                ],
              )),
        )));
  }
}
