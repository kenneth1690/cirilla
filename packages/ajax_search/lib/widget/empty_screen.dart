import 'package:flutter/material.dart';

class EmptyResultAjaxScreen extends StatelessWidget {
  final IconData iconData;
  final double? width;
  final double? height;
  final double radius;
  final Widget title;
  final Widget content;
  final Widget? textButton;
  final VoidCallback? onPressed;
  final Color? color;
  final ButtonStyle? styleBtn;
  final bool isButton;
  const EmptyResultAjaxScreen({
    Key? key,
    required this.iconData,
    required this.title,
    required this.content,
    this.textButton,
    this.onPressed,
    this.width = 219,
    this.height = 129,
    this.radius = 110,
    this.color,
    this.styleBtn,
    this.isButton = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                topRight: Radius.circular(radius),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.2, 1],
                colors: [
                  color?.withOpacity(0.1) ?? Theme.of(context).primaryColor.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 91),
                Icon(iconData, color: color ?? Theme.of(context).primaryColor, size: 36),
              ],
            ),
          ),
          const SizedBox(height: 20),
          title,
          const SizedBox(height: 8),
          content,
          const SizedBox(height: 40),
          if (isButton)
            SizedBox(
              height: 48,
              child: ElevatedButton(onPressed: onPressed, style: styleBtn, child: textButton),
            )
        ],
      ),
    );
  }
}
