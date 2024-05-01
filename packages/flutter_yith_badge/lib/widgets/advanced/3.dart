import 'package:flutter/material.dart';

class Advanced3 extends StatelessWidget {
  final Color background;
  final Color textColor;
  final String text;

  const Advanced3({
    Key? key,
    required this.background,
    required this.textColor,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: background,
          padding: EdgeInsets.symmetric(horizontal: 13, vertical: 3),
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: textColor)),
        ),
        Center(
          child: Container(
            width: 6,
            height: 6,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: 3, color: Colors.transparent),
                  right: BorderSide(width: 3, color: Colors.transparent),
                  top: BorderSide(width: 6, color: background),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
