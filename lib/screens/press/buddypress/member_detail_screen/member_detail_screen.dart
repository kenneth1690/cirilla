import 'dart:convert';

import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../better_messages/better_messages.dart';
import '../../constants.dart';
import '../buddypress.dart';

import 'constants.dart';
import 'member_appbar.dart';
import 'member_profile.dart';
import 'member_tab.dart';

class BPMemberDetailScreen extends StatefulWidget {
  static const routeName = '/buddypress-member-detail';

  final Map? args;
  final SettingStore? store;

  const BPMemberDetailScreen({
    super.key,
    this.store,
    this.args,
  });

  @override
  State<BPMemberDetailScreen> createState() => _BPMemberDetailScreenState();
}

class _BPMemberDetailScreenState extends State<BPMemberDetailScreen> with AppBarMixin, SnackMixin, LoadingMixin {
  late BPMemberDetailStore _memberStore;

  @override
  void initState() {
    BPMember? member = widget.args?["member"] is BPMember ? widget.args!["member"] : null;
    int id = member?.id ?? ConvertData.stringToInt(widget.args?["id"]);

    _memberStore = BPMemberDetailStore(widget.store!.requestHelper, id: id, member: member)..getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(
      builder: (_) {
        if (_memberStore.loading) {
          return Scaffold(
            appBar: baseStyleAppBar(context, title: ""),
            body: Center(
              child: buildLoading(context, isLoading: _memberStore.loading),
            ),
          );
        }

        if (_memberStore.errorMessage?.isNotEmpty == true) {
          return Scaffold(
            appBar: baseStyleAppBar(context, title: ""),
            body: Center(
              child: Text(_memberStore.errorMessage!),
            ),
          );
        }

        if (_memberStore.member?.id == null) {
          return Scaffold(
            appBar: baseStyleAppBar(context, title: ""),
            body: Center(
              child: Text(translate("buddypress_member_no")),
            ),
          );
        }

        return _ContentDetail(
          store: _memberStore,
          settingStore: widget.store,
          translate: translate,
          callback: widget.args?["callback"] as Function(int? id, String slug)?,
        );
      },
    );
  }
}

class _ContentDetail extends StatefulWidget {
  final BPMemberDetailStore store;
  final SettingStore? settingStore;
  final TranslateType translate;
  final Function(int? id, String slug)? callback;

  const _ContentDetail({
    required this.store,
    this.settingStore,
    required this.translate,
    this.callback,
  });

  @override
  State<_ContentDetail> createState() => _ContentDetailState();
}

class _ContentDetailState extends State<_ContentDetail>
    with LoadingMixin, TransitionMixin, SingleTickerProviderStateMixin {
  late AuthStore _authStore;
  late TabController _tabController;

  late List<String> _tabKey;
  late String _visitTab;

  late BPActivityStore _activityStore;
  final ScrollController _controller = ScrollController();

  late bool _enableMentionName;
  late bool _enableActivities;
  late bool _enableMessages;
  late bool _enablePublishMessage;
  late bool _enablePrivateMessage;

  @override
  void initState() {
    Data? dataScreen = widget.settingStore?.data?.extraScreens?["buddypress-member"];
    Map<String, dynamic>? configs = dataScreen?.configs;
    String jsonData = get(configs, ["dataJson"], "");

    Map? data = isJSON(jsonData) ? jsonDecode(jsonData) : null;

    _enableActivities = ConvertData.toBoolValue(get(data, ["enableActivities"])) ?? true;
    _enableMessages = ConvertData.toBoolValue(get(data, ["enableMessages"])) ?? true;
    _enablePublishMessage = ConvertData.toBoolValue(get(data, ["enablePublishMessage"])) ?? true;
    _enablePrivateMessage = ConvertData.toBoolValue(get(data, ["enablePrivateMessage"])) ?? true;
    _enableMentionName = ConvertData.toBoolValue(get(data, ["enableMentionName"])) ?? true;

    _controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);

    _tabKey = _authStore.isLogin && _authStore.user?.id == widget.store.member?.id?.toString()
        ? [if (_enableActivities) "activity", "profile", if (_enableMessages) "messages", "friends"]
        : [if (_enableActivities) "activity", "profile", "friends"];
    _tabController = TabController(vsync: this, length: _tabKey.length);
    _visitTab = _tabKey[0];
    _activityStore = BPActivityStore(
      widget.settingStore!.requestHelper,
      userId: widget.store.member?.id,
      displayComments: "stream",
    );
    if (_enableActivities) _activityStore.getActivities();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _activityStore.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_visitTab == "_visitTab") {
      if (!_controller.hasClients || _activityStore.loading || !_activityStore.canLoadMore) return;
      final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

      if (thresholdReached) {
        _activityStore.getActivities();
      }
    }
  }

  List<Widget> buildContent(TranslateType translate) {
    switch (_visitTab) {
      case "profile":
        return [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverToBoxAdapter(
              child: MemberProfile(member: widget.store.member),
            ),
          ),
        ];
      default:
        bool loading = _activityStore.loading;
        List<BPActivity> activities = _activityStore.activities;
        List<BPActivity> emptyActivity = List.generate(_activityStore.perPage, (index) => BPActivity()).toList();

        List<BPActivity> data = loading && activities.isEmpty ? emptyActivity : activities;
        return [
          CupertinoSliverRefreshControl(
            onRefresh: _activityStore.refresh,
            builder: buildAppRefreshIndicator,
          ),
          if (data.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 24),
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
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Scaffold(
      body: Observer(
        builder: (_) {
          return CustomScrollView(
            controller: _controller,
            slivers: [
              MemberAppbarWidget(
                member: widget.store.member,
                banner: widget.store.banner,
                callback: widget.callback,
                type: typeView,
                enableMentionName: _enableMentionName,
                enablePublishMessage: _enablePublishMessage,
                enablePrivateMessage: _enablePrivateMessage,
              ),
              MemberTabWidget(
                tabs: _tabKey,
                controller: _tabController,
                onChanged: (String visit) {
                  switch (visit) {
                    case "messages":
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, _, __) {
                            if (messagePlugin == "BetterMessages") {
                              return BMMessageListScreen(
                                store: widget.settingStore,
                              );
                            }
                            return BPMessageListScreen(
                              store: widget.settingStore,
                            );
                          },
                          transitionsBuilder: slideTransition,
                        ),
                      );
                      int index = _tabKey.indexOf(_visitTab);
                      _tabController.animateTo(index);
                      break;
                    case "friends":
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, _, __) {
                            return BPMemberFriendScreen(
                              store: widget.settingStore,
                              args: {
                                "id": widget.store.member?.id,
                              },
                              onActionCallback: widget.callback,
                            );
                          },
                          transitionsBuilder: slideTransition,
                        ),
                      );
                      int index = _tabKey.indexOf(_visitTab);
                      _tabController.animateTo(index);
                      break;

                    default:
                      setState(() {
                        _visitTab = visit;
                      });
                  }
                },
                translate: widget.translate,
              ),
              ...buildContent(translate),
            ],
          );
        },
      ),
    );
  }
}
