import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'models/models.dart';
import 'stores/stores.dart';
import 'widgets/widgets.dart';

class BPGroupListScreen extends StatefulWidget {
  static const routeName = '/buddypress-group-list';

  final Map? args;
  final SettingStore? store;

  const BPGroupListScreen({
    super.key,
    this.args,
    this.store,
  });

  @override
  State<BPGroupListScreen> createState() => _BPGroupListScreenState();
}

class _BPGroupListScreenState extends State<BPGroupListScreen> with AppBarMixin, LoadingMixin {
  late BPGroupStore _groupStore;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    int page = ConvertData.stringToInt(get(widget.args, ["page"]), 1);
    int perPage = ConvertData.stringToInt(get(widget.args, ["perPage"]), 10);
    String? initFilter = get(widget.args, ["initFilter"]);

    _groupStore = BPGroupStore(widget.store!.requestHelper, page: page, perPage: perPage, type: initFilter)..getGroups();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _groupStore.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients || _groupStore.loading || !_groupStore.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _groupStore.getGroups();
    }
  }

  void _onFilter() async {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    List<OptionFilter> options = [
      OptionFilter(key: "active", text: translate("buddypress_last_active")),
      OptionFilter(key: "popular", text: translate("buddypress_most_member")),
      OptionFilter(key: "newest", text: translate("buddypress_new_created")),
      OptionFilter(key: "alphabetical", text: translate("buddypress_alphabetical")),
    ];

    String? value = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {

        double height = MediaQuery.of(context).size.height;

        return Container(
          constraints: BoxConstraints(maxHeight: height / 2),
          padding: paddingHorizontal,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: itemPaddingMedium, bottom: itemPaddingLarge),
                child: Text(translate("buddypress_filter"), style: theme.textTheme.titleMedium),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: ModalFilterWidget(
                    value: _groupStore.type,
                    options: options,
                    onSelected: (key) => Navigator.pop(context, key),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
    );
    if (value != null && value != _groupStore.type) {
      _groupStore.onChanged(type: value);
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    bool loadMore = ConvertData.toBoolValue(get(widget.args, ["loadMore"])) ?? true;
    bool showSearch = ConvertData.toBoolValue(get(widget.args, ["showSearch"])) ?? true;
    bool showFilter = ConvertData.toBoolValue(get(widget.args, ["showFilter"])) ?? true;
    String? name = get(widget.args, ["name"]);

    return Scaffold(
      appBar: baseStyleAppBar(
        context,
        title: name?.isNotEmpty == true ? name! : translate("buddypress_group_list"),
        actions: showFilter
            ? [
                IconButton(onPressed: _onFilter, icon: const Icon(FeatherIcons.sliders, size: 20)),
                const SizedBox(width: 12),
              ]
            : null,
      ),
      body: Observer(
        builder: (_) {
          bool loading = _groupStore.loading;
          List<BPGroup> groups = _groupStore.groups;
          List<BPGroup> emptyGroup = List.generate(_groupStore.perPage, (index) => BPGroup()).toList();

          List<BPGroup> data = loading && groups.isEmpty ? emptyGroup : groups;
          return CustomScrollView(
            controller: loadMore ? _controller : null,
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: _groupStore.refresh,
                builder: buildAppRefreshIndicator,
              ),
              if (showSearch)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: SearchWidget(
                      initialValue: _groupStore.search,
                      onChanged: (value) => _groupStore.onChanged(search: value),
                    ),
                  ),
                ),
              if (data.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, index) => GroupItemWidget(group: data[index]),
                      childCount: data.length,
                    ),
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: Center(
                    child: Text(translate("buddypress_empty")),
                  ),
                ),
              if (loadMore && loading && groups.isNotEmpty)
                SliverToBoxAdapter(
                  child: buildLoading(context, isLoading: _groupStore.canLoadMore),
                ),
            ],
          );
        },
      ),
    );
  }
}
