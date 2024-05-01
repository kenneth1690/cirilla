import 'package:flutter/material.dart';

class LayoutContent extends StatelessWidget {
  final int length;
  final int col;
  final Widget Function(int visit, double width) onRenderItem;
  // Horizontal spacing
  final double spacing;

  // Vertical spacing
  final double runSpacing;
  final double widthView;

  const LayoutContent({
    super.key,
    required this.onRenderItem,
    this.length = 0,
    this.col = 1,
    this.spacing = 0,
    this.runSpacing = 0,
    this.widthView = 300,
  }) : assert(col > 0);

  @override
  Widget build(BuildContext context) {
    if (length > 0) {
      if (col == 1) {
        return Column(
          children: List.generate(length, (i) {
            double padBottom = i < length - 1 ? runSpacing : 0;
            return Padding(
              padding: EdgeInsets.only(bottom: padBottom),
              child: onRenderItem(i, widthView),
            );
          }),
        );
      }

      int row = (length / col).ceil();
      double widthItem = (widthView - spacing * (col - 1))/col;

      return Column(
        children: List.generate(row, (i) {
          double padBottom = i < row - 1 ? runSpacing : 0;

          return Padding(
            padding: EdgeInsets.only(bottom: padBottom),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(col, (j) => SizedBox(width: widthItem, child: i * col + j < length ? onRenderItem(i * col + j, widthItem) : null))
            ),
          );
        }),
      );
    }
    return Container();
  }
}