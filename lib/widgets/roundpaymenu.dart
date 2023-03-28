import 'package:flutter/material.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter_svg/svg.dart';

class RoundPayMenu extends StatelessWidget {
  final String label;

  final Function()? onPressed;

  final int actived;
  final String img;
  const RoundPayMenu({
    Key? key,
    required this.label,
    this.onPressed,
    required this.actived,
    this.img = "setting.svg",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(right: 10),
                width: 40,
                child: SvgPicture.asset(
                  'assets/icons/pay_screen/$img',
                  height: (_size.height / 100) * 4,
                  allowDrawingOutsideViewBox: true,
                )),
            Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
        ),
        style: TextButton.styleFrom(
          backgroundColor: actived == 0
              ? global.posTheme.secondary
              : global.posTheme.background,
        ),
      ),
    );
  }
}
