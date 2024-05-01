import 'package:flutter/material.dart';

class Css14 extends StatelessWidget {
  final Color background;
  final Widget text;

  const Css14({
    Key? key,
    required this.background,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    TextStyle? textHeading = theme.textTheme.labelSmall?.copyWith(fontSize: 10, fontWeight: FontWeight.w700);
    return IntrinsicWidth(
      child: Column(
        children: [
          Container(
            color: Colors.black,
            padding: EdgeInsets.all(1.5),
            child: Row(
              children: [
                Expanded(child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  alignment: Alignment.center,
                  child: Text("Black", style: textHeading?.copyWith(color: Colors.white),),
                ),),
                Expanded(child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  alignment: Alignment.center,
                  child: Text("Friday", style: textHeading?.copyWith(color: Colors.black)),
                ),),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(6),
            alignment: Alignment.center,
            color: background,
            child: text,
          ),
        ],
      ),
    );
  }
}
