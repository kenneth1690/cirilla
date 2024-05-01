import 'package:flutter/material.dart';

double _getViewEnd(double width) {
  if (width > 840) {
    return width * 2/5 < 499 ? width * 2/5 : 499;
  }
  if (width > 600) {
    return width/2;
  }
  return width;
}

double _getPadEnd(double widthEnd, double widthView) {
  if (widthEnd == widthView) {
    return 0;
  }
  return widthEnd;
}

class ViewContent extends StatefulWidget {
  final bool enableEnd;
  final Widget startWidget;
  final Widget endWidget;
  const ViewContent({super.key, this.enableEnd = true, required this.startWidget, required this.endWidget,});

  @override
  State<StatefulWidget> createState() => _ViewContentState();
}

class _ViewContentState extends State<ViewContent> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    double widthEnd = _getViewEnd(mediaQuery.size.width);
    double padEnd = _getPadEnd(widthEnd, mediaQuery.size.width);

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsetsDirectional.only(end: widget.enableEnd ? padEnd : 0),
          child: widget.startWidget,
        ),
        if (widget.enableEnd)
        PositionedDirectional(top: 0, bottom: 0, end: 0, width: widthEnd, child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: widget.endWidget,
        )),
        if (widget.enableEnd && padEnd > 0)
        PositionedDirectional(top: 0, bottom: 0, end: widthEnd + 1, child: const VerticalDivider(width: 1, thickness: 1)),
      ],
    );
  }
}