import 'package:cirilla/models/models.dart';
import 'package:flutter/material.dart';

import 'icon_scan.dart';
import 'search_widget.dart';

class ProductSearchWidget extends StatelessWidget {
  final WidgetConfig? widgetConfig;

  const ProductSearchWidget({
    Key? key,
    this.widgetConfig,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ProductSearchWidget(
      widgetConfig: widgetConfig,
      scan: (Color? color) => IconScan(color: color),
    );
  }
}

class _ProductSearchWidget extends SearchWidget {
  final WidgetConfig? widgetConfig;
  final Widget Function(Color?)? scan;

  const _ProductSearchWidget({
    Key? key,
    this.widgetConfig,
    this.scan,
  }) : super(
          key: key,
          widgetConfigData: widgetConfig,
          iconScan: scan,
        );
}