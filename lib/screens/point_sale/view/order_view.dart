import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/order/order.dart';
import 'package:cirilla/store/order/order_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/widgets/cirilla_order_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../widgets/heading_content.dart';
import '../widgets/icon_menu.dart';
import '../widgets/layout_content.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> with CategoryMixin, LoadingMixin {
  late SettingStore _settingStore;
  late OrderStore _orderStore;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    // Map<String, dynamic> sortInit = {
    //   'key': 'product_list_default',
    //   'query': {
    //     'orderby': 'title',
    //     'order': 'asc',
    //   }
    // };
    _settingStore = Provider.of<SettingStore>(context);
    _orderStore = OrderStore(
      _settingStore.requestHelper,
    )..getOrders();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients || _orderStore.loading || !_orderStore.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _orderStore.getOrders();
    }
  }

  void onChangeMenu(String key, List<String> selected) {
    // switch (key) {
    //   case "layout":
    //     if (selected.isNotEmpty) {
    //       setState(() {
    //         _layout = selected[0];
    //       });
    //     }
    //     break;
    //   case "orderby":
    //     if (selected.isNotEmpty) {
    //       Map<String, dynamic> sort = {
    //         'key': 'product_list_default',
    //         'query': {
    //           'order': _productStore.sort["query"]["order"] ?? "asc",
    //           'orderby': selected[0],
    //         }
    //       };
    //       _productStore.onChanged(sort: sort);
    //     }
    //     break;
    //   case "order":
    //     if (selected.isNotEmpty) {
    //       Map<String, dynamic> sort = {
    //         'key': 'product_list_default',
    //         'query': {
    //           'order': selected[0],
    //           'orderby': _productStore.sort["query"]["orderby"] ?? "title",
    //         }
    //       };
    //       _productStore.onChanged(sort: sort);
    //     }
    //     break;
    //   default:
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        List<OrderData> emptyOrders = List.generate(10, (index) => OrderData()).toList();
        List<OrderData> data = _orderStore.loading && _orderStore.orders.isEmpty ? emptyOrders : _orderStore.orders;
        Map sort = {};

        // String orderBy = sort["query"]["orderby"] ?? "title";
        // String order = sort["query"]["order"] ?? "asc";

        String orderBy = sort["query"]?["orderby"] ?? "id";
        String order = sort["query"]?["order"] ?? "asc";

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeadingContent(
              title: const Text("Search order"),
              trailing: IconMenuContent(
                items: [
                  // MenuItemContent(
                  //   key: "layout",
                  //   title: "Layout",
                  //   type: MenuItemType.single,
                  //   options: [
                  //     MenuOptionContent(key: "grid", title: "Grid", icon: Icons.grid_view),
                  //     MenuOptionContent(key: "rect", title: "Rectangular", icon: Icons.view_stream),
                  //     MenuOptionContent(key: "list", title: "List", icon: Icons.table_rows),
                  //   ],
                  //   selectedKeys: [_layout],
                  // ),
                  MenuItemContent(
                    key: "orderby",
                    title: "Sort by",
                    subtitle: IconButton(
                      onPressed: () => onChangeMenu("order", [order == "desc" ? "asc" : "desc"]),
                      icon: Icon(order == "desc" ? Icons.arrow_downward : Icons.arrow_upward, size: 14),
                      splashRadius: 15,
                      tooltip: order == "desc" ? "Descending" : "Ascending",
                      constraints: const BoxConstraints(maxWidth: 30, maxHeight: 30),
                    ),
                    type: MenuItemType.single,
                    options: [
                      MenuOptionContent(key: "date", title: "Date placed"),
                      MenuOptionContent(key: "id", title: "Order number"),
                    ],
                    selectedKeys: [orderBy],
                  ),
                ],
                onChange: onChangeMenu,
              ),
              padding: const EdgeInsetsDirectional.only(start: 20, end: 8),
            ),
            const Divider(height: 1, thickness: 1),
            Expanded(
              child: CustomScrollView(
                controller: _controller,
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: _orderStore.refresh,
                    builder: buildAppRefreshIndicator,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverToBoxAdapter(
                      child: _ListOrder(
                        orders: data,
                        layout: "",
                        orderStore: _orderStore,
                      ),
                    ),
                  ),
                  if (_orderStore.loading)
                    SliverToBoxAdapter(
                      child: buildLoading(context, isLoading: _orderStore.canLoadMore),
                    ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

class _ListOrder extends StatelessWidget {
  final List<OrderData> orders;
  final String layout;
  final OrderStore orderStore;

  const _ListOrder({
    required this.orders,
    required this.orderStore,
    this.layout = "rect",
  });

  Widget buildList(ThemeData theme) {
    return LayoutContent(
      col: 1,
      length: orders.length,
      runSpacing: 16,
      onRenderItem: (index, _) => buildItem(orders[index], theme),
      widthView: double.infinity,
    );
  }

  Widget buildItem(OrderData order, ThemeData theme) {
    return CirillaOrderItem(
      order: order,
      orderCancel: const [],
      orderStore: orderStore,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return buildList(theme);
  }
}
