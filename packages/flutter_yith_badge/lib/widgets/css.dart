import 'package:flutter/material.dart';

import 'package:flutter_yith_badge/models/model.dart';

import 'flip.dart';
import 'html.dart';

import 'css/1.dart';
import 'css/2.dart';
import 'css/3.dart';
import 'css/4.dart';
import 'css/5.dart';
import 'css/6.dart';
import 'css/7.dart';
import 'css/9.dart';
import 'css/10.dart';
import 'css/11.dart';
import 'css/12.dart';
import 'css/13.dart';
import 'css/14.dart';
import 'css/15.dart';
import 'css/16.dart';

class FlutterYithBadgeCss extends StatelessWidget {
  final YithBadgeModel config;
  final double widthParent;
  final double heightParent;

  const FlutterYithBadgeCss({
    Key? key,
    required this.config,
    required this.widthParent,
    required this.heightParent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget text = FlutterYithFlip(
      isFlip: config.isFlipText,
      type: config.flipText,
      child: TextHtml(html: config.text),
    );

    switch(config.css) {
      case "2.svg": {
        return Css2(
          background: config.background,
          text: text,
        );
      }
      case "3.svg": {
        return Css3(
          background: config.background,
          text: text,
        );
      }
      case "4.svg": {
        return Css4(
          background: config.background,
          text: text,
        );
      }
      case "5.svg": {
        return Css5(
          background: config.background,
          text: text,
        );
      }
      case "6.svg": {
        return Css6(
          background: config.background,
          text: text,
        );
      }
      case "7.svg": {
        return Css7(
          background: config.background,
          text: text,
        );
      }
      case "9.svg": {
        return Css9(
          background: config.background,
          text: text,
        );
      }
      case "10.svg": {
        return Css10(
          background: config.background,
          text: text,
        );
      }
      case "11.svg": {
        return Css11(
          background: config.background,
          text: text,
        );
      }
      case "12.svg": {
        return Css12(
          background: config.background,
          text: text,
        );
      }
      case "13.svg": {
        return Css13(
          background: config.background,
          text: text,
        );
      }
      case "14.svg": {
        return Css14(
          background: config.background,
          text: text,
        );
      }
      case "15.svg": {
        return Css15(
          background: config.background,
          text: text,
        );
      }
      case "16.svg": {
        return Css16(
          background: config.background,
          text: text,
        );
      }
      default:
        return Css1(
          background: config.background,
          text: text,
        );
    }
  }
}
