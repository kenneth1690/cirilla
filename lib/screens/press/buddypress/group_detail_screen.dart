import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'models/models.dart';
import 'stores/stores.dart';
import 'widgets/widgets.dart';

class BPGroupDetailScreen extends StatefulWidget {
  static const routeName = '/buddypress-group-detail';

  final Map? args;
  final SettingStore? store;

  const BPGroupDetailScreen({
    super.key,
    this.store,
    this.args,
  });

  @override
  State<BPGroupDetailScreen> createState() => _BPGroupDetailScreenState();
}

class _BPGroupDetailScreenState extends State<BPGroupDetailScreen> with SnackMixin, AppBarMixin, LoadingMixin {
  BPGroup? _group;
  bool _loading = false;

  @override
  void initState() {
    if (widget.args?["group"] is BPGroup) {
      _group = widget.args?["group"];
    } else if (ConvertData.stringToInt(widget.args?["id"]) != 0) {
      getGroup(ConvertData.stringToInt(widget.args?["id"]));
    }
    super.initState();
  }

  void getGroup(int id) async {
    try {
      setState(() {
        _loading = true;
      });
      BPGroup? data = await widget.store?.requestHelper.getGroup(
        id: id,
        queryParameters: {
          "populate_extras": true
        }
      );
      setState(() {
        _loading = false;
        if (data is BPGroup) {
          _group = data;
        }
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    if (_loading && _group?.id == null) {
      return Scaffold(
        appBar: baseStyleAppBar(context, title: translate("buddypress_group")),
        body: Center(
          child: buildLoading(context, isLoading: _loading),
        ),
      );
    }

    if (_group?.id == null) {
      return Scaffold(
        appBar: baseStyleAppBar(context, title: translate("buddypress_group")),
        body: Center(
          child: Text(translate("buddypress_group_no")),
        ),
      );
    }

    return _ContentGroup(
      group: _group!,
      store: widget.store,
    );
  }
}

class _ContentGroup extends StatefulWidget {
  final BPGroup group;
  final SettingStore? store;

  const _ContentGroup({
    required this.group,
    this.store,
  });

  @override
  State<_ContentGroup> createState() => _ContentGroupState();
}

class _ContentGroupState extends State<_ContentGroup> with LoadingMixin {
  late AuthStore _authStore;
  late BPActivityStore _activityStore;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);
    _activityStore = BPActivityStore(
      widget.store!.requestHelper,
      groupId: widget.group.id,
      displayComments: "stream",
    )..getActivities();
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

  void onUpdate() async {
    String? value = await showModalBottomSheet<String?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: borderRadiusBottomSheet,
      ),
      builder: (BuildContext context) {
        double height = MediaQuery.of(context).size.height;
        return Container(
          constraints: BoxConstraints(maxHeight:  height * 0.7),
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: UpdateActivityGroupFormWidget(
            id: widget.group.id,
            callback: () => Navigator.of(context).pop("OK"),
          ),
        );
      },
    );
    if (value == "OK") {
      _activityStore.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(
      builder: (_) {
        bool loading = _activityStore.loading;
        List<BPActivity> activities = _activityStore.activities;
        List<BPActivity> emptyActivity = List.generate(_activityStore.perPage, (index) => BPActivity()).toList();

        List<BPActivity> data = loading && activities.isEmpty ? emptyActivity : activities;

        return Scaffold(
          bottomNavigationBar: _authStore.isLogin ?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: ElevatedButton(
                  onPressed: onUpdate,
                  child: Text(translate("buddypress_group_update_activity")),
                )
              ) :
              null,
          body: CustomScrollView(
            controller: _controller,
            slivers: [
              GroupAppbarWidget(group: widget.group),
              CupertinoSliverRefreshControl(
                onRefresh: _activityStore.refresh,
                builder: buildAppRefreshIndicator,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(translate("buddypress_group_activities"), style: Theme.of(context).textTheme.titleMedium),
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
                  child: Center(
                    child: Text(translate("buddypress_empty")),
                  ),
                ),
              if (loading && activities.isNotEmpty)
                SliverToBoxAdapter(
                  child: buildLoading(context, isLoading: _activityStore.canLoadMore),
                ),
            ],
          ),
        );
      },
    );
  }
}