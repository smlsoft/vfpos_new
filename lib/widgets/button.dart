import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dedepos/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NumPadButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final bool haveBorder;
  final Function callBack;
  final Color? color;
  final Color? textAndIconColor;

  const NumPadButton(
      {Key? key,
      this.text,
      this.icon,
      this.haveBorder = true,
      required this.callBack,
      this.color,
      this.textAndIconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget label = icon != null
        ? FittedBox(
            fit: BoxFit.fill,
            child: Icon(icon,
                color: (textAndIconColor == null)
                    ? Colors.white
                    : textAndIconColor))
        : Text(text ?? "",
            style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                shadows: const [
                  Shadow(
                    blurRadius: 1.0,
                    color: Colors.black,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
                color: ((textAndIconColor == null)
                    ? Colors.white
                    : textAndIconColor)));

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: (color == null) ? Colors.blue : color,
            minimumSize: Size.zero,
            padding: const EdgeInsets.only(left: 4, right: 4)),
        onPressed: () {
          global.playSound(sound: global.SoundEnum.buttonTing);
          callBack.call();
        },
        child: FittedBox(fit: BoxFit.scaleDown, child: label),
      ),
    );
  }
}

class CommandButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool haveBorder;
  final VoidCallback onPressed;
  final Color? labelColor;
  final Color? primaryColor;
  final double? height;
  final double width;
  final Color? iconColor;
  final String imgAssetPath;

  const CommandButton(
      {Key? key,
      this.label = "",
      this.icon,
      this.haveBorder = true,
      required this.onPressed,
      this.labelColor = Colors.black,
      this.primaryColor,
      this.height = 50,
      this.width = 100,
      this.imgAssetPath = "",
      this.iconColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle buttonStyle = TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: (labelColor == null)
            ? Theme.of(context).scaffoldBackgroundColor
            : labelColor);
    Widget labelAndStyle = Text(
      label,
      style: buttonStyle,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    );

    return Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: primaryColor,
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: () {
                onPressed();
              },
              child: (imgAssetPath.isEmpty)
                  ? Center(child: labelAndStyle)
                  : (label.isEmpty)
                      ? FittedBox(
                          fit: BoxFit.fill, child: Image.asset(imgAssetPath))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: (imgAssetPath.isNotEmpty)
                                    ? Image.asset(imgAssetPath)
                                    : Container()),
                            FittedBox(
                                fit: BoxFit.fitWidth, child: labelAndStyle)
                          ],
                        )),
        ));
  }
}
