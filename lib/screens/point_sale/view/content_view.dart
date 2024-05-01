import 'package:awesome_icons/awesome_icons.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import 'category_product_view.dart';
import 'order_view.dart';

class ContentView extends StatefulWidget {
  const ContentView({super.key});

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: theme.primaryColor,
          child: TabBar(
            controller: _controller,
            isScrollable: true,
            labelPadding: const EdgeInsets.symmetric(horizontal: 20),
            labelStyle: theme.textTheme.titleSmall,
            labelColor: theme.primaryColor,
            unselectedLabelStyle: theme.textTheme.bodyMedium,
            unselectedLabelColor: theme.colorScheme.onPrimary,
            indicator: BoxDecoration(
                color: theme.cardColor, border: Border(bottom: BorderSide(width: 1, color: theme.primaryColor))),
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [const Icon(FeatherIcons.layers, size: 19), const SizedBox(width: 12), Text(translate("point_sale_products"))],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [const Icon(FontAwesomeIcons.receipt, size: 17), const SizedBox(width: 12), Text(translate("point_sale_orders"))],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              CategoryProductView(),
              OrderView(),
            ],
          ),
        )
      ],
    );
  }
}
