import 'package:flutter/material.dart';
import 'package:flutter_yith_badge/convert_data.dart';

class Css7 extends StatelessWidget {
  final Color background;
  final Widget text;

  const Css7({
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
          color: background,
          padding: EdgeInsets.fromLTRB(8, 3, 10, 3),
          margin: EdgeInsets.only(left: 13),
          child: text,
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          width: 13,
          child: LayoutBuilder(
            builder: (_, BoxConstraints constraints) {
              double height = constraints.maxHeight;
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(width: 13, color: background),
                        bottom: BorderSide(width: height / 2, color: Colors.transparent),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(width: 13, color: background),
                        top: BorderSide(width: height / 2, color: Colors.transparent),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
        Positioned(
          bottom: -6,
          right: 0,
          child: Container(
            width: 7,
            height: 6,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: 2, color: Colors.transparent),
                  right: BorderSide(width: 5, color: Colors.transparent),
                  top: BorderSide(width: 6, color: ConvertData.darkenColor(background)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
