import 'package:awesome_icons/awesome_icons.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'activity_create_screen.dart';
import 'models/models.dart';
import 'stores/stores.dart';
import 'widgets/widgets.dart';

class BPActivityListScreen extends StatefulWidget {
  static const routeName = '/buddypress-activity-list';

  final Map? args;
  final SettingStore? store;

  const BPActivityListScreen({
    super.key,
    this.args,
    this.store,
  });

  @override
  State<BPActivityListScreen> createState() => _BPActivityListScreenState();
}

class _BPActivityListScreenState extends State<BPActivityListScreen> with AppBarMixin, LoadingMixin, TransitionMixin {
  late AuthStore _authStore;
  late BPActivityStore _activityStore;
  final ScrollController _controller = ScrollController();

  late String? _mentionName;

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);

    int page = ConvertData.stringToInt(get(widget.args, ["page"]), 1);
    int perPage = ConvertData.stringToInt(get(widget.args, ["perPage"]), 10);
    String? initFilter = get(widget.args, ["initFilter"]);
    _activityStore = BPActivityStore(widget.store!.requestHelper, page: page, perPage: perPage, type: initFilter)
      ..getActivities();
    _mentionName = get(widget.args, ["mentionName"]) as String?;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _activityStore.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients || _activityStore.loading || !_activityStore.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _activityStore.getActivities();
    }
  }

  void _onFilter() async {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
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
                  child: ActivityFilterList(
                    value: _activityStore.type,
                    onChanged: (key) => Navigator.pop(context, key),
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
    if (value != null && value != _activityStore.type) {
      _activityStore.onChanged(type: value);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_mentionName?.isNotEmpty == true) {
      return BPActivityCreateScreen(
        enablePublishMessage: true,
        mentionName: _mentionName,
        callback: () {
          setState(() {
            _mentionName = null;
          });
          _activityStore.getActivities();
        },
      );
    }

    TranslateType translate = AppLocalizations.of(context)!.translate;

    bool loadMore = ConvertData.toBoolValue(get(widget.args, ["loadMore"])) ?? true;
    bool showSearch = ConvertData.toBoolValue(get(widget.args, ["showSearch"])) ?? true;
    bool showFilter = ConvertData.toBoolValue(get(widget.args, ["showFilter"])) ?? true;
    String? name = get(widget.args, ["name"]);

    return Observer(builder: (_) {
      bool loading = _activityStore.loading;
      List<BPActivity> activities = _activityStore.activities;
      List<BPActivity> emptyActivity = List.generate(_activityStore.perPage, (index) => BPActivity()).toList();

      List<BPActivity> data = loading && activities.isEmpty ? emptyActivity : activities;
      return Scaffold(
        appBar: baseStyleAppBar(context,
            title: name?.isNotEmpty == true ? name! : translate("buddypress_activity"),
            actions: [
              if (_authStore.isLogin)
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, _, __) => BPActivityCreateScreen(
                          callback: () => Navigator.pop(context, "OK"),
                        ),
                        transitionsBuilder: slideTransition,
                      ),
                    ).then((value) {
                      if (value == "OK") {
                        _activityStore.initQuery();
                      }
                    });
                  },
                  icon: const Icon(FontAwesomeIcons.plusCircle, size: 20),
                  splashRadius: 25,
                  constraints: const BoxConstraints(maxWidth: 35, maxHeight: 35),
                ),
              if (showFilter)
                IconButton(
                  onPressed: _onFilter,
                  icon: const Icon(FeatherIcons.sliders, size: 20),
                  splashRadius: 25,
                  constraints: const BoxConstraints(maxWidth: 35, maxHeight: 35),
                ),
              const SizedBox(width: 14)
            ]),
        body: CustomScrollView(
          controller: loadMore ? _controller : null,
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: _activityStore.refresh,
              builder: buildAppRefreshIndicator,
            ),
            if (showSearch)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SearchWidget(
                    initialValue: _activityStore.search,
                    onChanged: (value) => _activityStore.onChanged(search: value),
                  ),
                ),
              ),
            if (data.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) => ActivityItemWidget(
                      activity: data[index],
                      callback: (_) => _activityStore.refresh(),
                    ),
                    childCount: data.length,
                  ),
                ),
              )
            else
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Center(
                    child: Text(translate("buddypress_empty")),
                  ),
                ),
              ),
            if (loadMore && loading && activities.isNotEmpty)
              SliverToBoxAdapter(
                child: buildLoading(context, isLoading: _activityStore.canLoadMore),
              ),
          ],
        ),
      );
    });
  }
}
