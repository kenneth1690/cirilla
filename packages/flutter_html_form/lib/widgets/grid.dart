import 'package:flutter/material.dart';

double _getSpacing(double width) {
  if (width >= 1536) {
    return 32;
  }
  if (width >= 640) {
    return 20;
  }
  return 16;
}

int _getCol(double width) {
  if (width >= 1536) {
    return 6;
  }
  if (width >= 1280) {
    return 6;
  }
  if (width >= 1024) {
    return 4;
  }
  if (width >= 640) {
    return 3;
  }
  if (width >= 320) {
    return 2;
  }
  return 1;
}

class GridWidget extends StatelessWidget {
  final int count;
  final Widget Function(int index, double width) buildItem;

  const GridWidget({
    Key? key,
    required this.count,
    required this.buildItem,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (count < 1) {
      return SizedBox();
    }

    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        double widthView = constraints.maxWidth;

        double spacing = _getSpacing(widthView);
        int col = _getCol(widthView);

        int row = (count/col).ceil();

        double widthItem = (widthView - (col - 1) * spacing) / col;

        return ListView.separated(
          itemBuilder: (_, int i) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(col, (int j) {
                int visit = (i * col) + j;

                return SizedBox(
                  width: widthItem,
                  child: visit < count ? buildItem(visit, widthItem) : null,
                );
              }),
            );
          },
          separatorBuilder: (_, __) => SizedBox(height: spacing),
          itemCount: row,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        );
      },
    );
  }
}
