import 'package:flutter/material.dart';
import 'package:flutter_yith_badge/convert_data.dart';

class Css16 extends StatelessWidget {
  final Color background;
  final Widget text;

  const Css16({
    Key? key,
    required this.background,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(3, 5, 7, 5),
          decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              )
          ),
          child: text,
        ),
        Positioned(
          top: 0,
          bottom: -6,
          left: -5,
          width: 5,
          child: Container(
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(4, 4),
                bottomLeft: Radius.elliptical(4, 4),
              ),
            ),
            alignment: Alignment.bottomRight,
            child: Container(
              height: 5,
              width: 4,
              margin: EdgeInsets.only(bottom: 1),
              decoration: BoxDecoration(
                color: ConvertData.darkenColor(background),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(3, 3),
                  bottomLeft: Radius.elliptical(3, 3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}