import 'package:flutter/material.dart';

class Css13 extends StatelessWidget {
  final Color background;
  final Widget text;

  const Css13({
    Key? key,
    required this.background,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
          left: -8,
          right: -8,
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double size = constraints.maxWidth;
                return Container(
                  width: size,
                  height: size,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: background),
                      shape: BoxShape.circle
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: background,
                        shape: BoxShape.circle
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Container(padding: EdgeInsets.all(15), child: text),
      ],
    );
  }
}

// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
//
// class Css13 extends StatelessWidget {
//   final Color background;
//   final Widget text;
//
//   const Css13({
//     Key? key,
//     required this.background,
//     required this.text,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       clipBehavior: Clip.none,
//       alignment: Alignment.center,
//       children: [
//         Positioned(
//           left: 0,
//           right: 0,
//           child: Center(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 double size = constraints.maxWidth;
//                 return Container(
//                   width: size,
//                   height: size,
//                   padding: EdgeInsets.all(6),
//                   decoration: BoxDecoration(color: background, shape: BoxShape.circle),
//                   child: DottedBorder(
//                     borderType: BorderType.Circle,
//                     padding: EdgeInsets.zero,
//                     color: Colors.white,
//                     dashPattern: [1.5, 2.5],
//                     strokeWidth: 1.5,
//                       // strokeCap: StrokeCap.round,
//                     child: Container(),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//         Container(padding: EdgeInsets.all(15), child: text),
//       ],
//     );
//   }
// }
