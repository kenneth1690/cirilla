import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../utils.dart';
import 'models/models.dart';
import 'stores/stores.dart';
import 'widgets/widgets.dart';

class BPMemberFriendScreen extends StatefulWidget {
  static const routeName = '/buddypress-member-friend';

  final Map? args;
  final int initTab;
  final SettingStore? store;
  final Function(int? id, String currentType)? onActionCallback;

  const BPMemberFriendScreen({
    super.key,
    this.args,
    this.store,
    this.initTab = 0,
    this.onActionCallback,
  });

  @override
  State<BPMemberFriendScreen> createState() => _BPMemberFriendScreenState();
}

class _BPMemberFriendScreenState extends State<BPMemberFriendScreen>
    with AppBarMixin, LoadingMixin, SingleTickerProviderStateMixin {
  late AuthStore _authStore;

  late TabController _tabController;
  late int _visit;

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);
    _visit = widget.initTab == 0 || widget.initTab == 1 ? widget.initTab : 0;
    _tabController = TabController(vsync: this, length: 2, initialIndex: _visit);

    super.didChangeDependencies();
  }

  Widget buildTab({required String title}) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    int id = ConvertData.stringToInt(get(widget.args, ["id"], _authStore.user?.id));

    if (id == 0) {
      return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          leading: leading(),
          centerTitle: true,
          title: Text(
            translate("buddypress_friends"),
            style: theme.appBarTheme.titleTextStyle,
          ),
        ),
        body: Center(
          child: Text(translate("buddypress_member_no")),
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        leading: leading(),
        centerTitle: true,
        title: Text(
          translate("buddypress_friends"),
          style: theme.appBarTheme.titleTextStyle,
        ),
        bottom: _authStore.user?.id == id.toString()
            ? TabBar(
                onTap: (int index) {
                  if (index != _visit) {
                    setState(() {
                      _visit = index;
                    });
                  }
                },
                labelPadding: EdgeInsets.zero,
                labelColor: theme.primaryColor,
                controller: _tabController,
                labelStyle: theme.textTheme.titleSmall,
                unselectedLabelColor: theme.textTheme.titleSmall?.color,
                indicatorWeight: 2,
                indicatorColor: theme.primaryColor,
                tabs: [
                  buildTab(title: translate("buddypress_friends_friendship")),
                  buildTab(title: translate("buddypress_friends_request")),
                ],
              )
            : null,
      ),
      body: _visit == 1 ? _ListRequiredFriend(id: id, onActionCallback: widget.onActionCallback,) : _ListFriend(id: id, onActionCallback: widget.onActionCallback,),
    );
  }
}

class _ListFriend extends StatefulWidget {
  final int id;
  final Function(int? id, String currentType)? onActionCallback;

  const _ListFriend({
    required this.id,
    this.onActionCallback,
  });

  @override
  State<_ListFriend> createState() => _ListFriendState();
}

class _ListFriendState extends State<_ListFriend> with LoadingMixin {
  late SettingStore _settingStore;
  late BPMemberStore _memberStore;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);

    _memberStore = BPMemberStore(_settingStore.requestHelper, page: 1, perPage: 10, userId: widget.id)..getMembers();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _memberStore.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients || _memberStore.loading || !_memberStore.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _memberStore.getMembers();
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(
      builder: (_) {
        bool loading = _memberStore.loading;
        List<BPMember> users = _memberStore.members;
        List<BPMember> emptyMember = List.generate(_memberStore.perPage, (index) => BPMember()).toList();

        List<BPMember> data = loading && users.isEmpty ? emptyMember : users;
        return CustomScrollView(
          controller: _controller,
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: _memberStore.refresh,
              builder: buildAppRefreshIndicator,
            ),
            if (data.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (_, index) => MemberItemWidget(
                      member: data[index],
                      onActionCallback: (int? id, String slug) {
                        _memberStore.onChanged(members: changeMemberFriendSlug(users, {
                          id?? 0: slug,
                        }, "is_friend"));
                        widget.onActionCallback?.call(id, slug);
                      },
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
            if (loading && users.isNotEmpty)
              SliverToBoxAdapter(
                child: buildLoading(context, isLoading: _memberStore.canLoadMore),
              ),
          ],
        );
      },
    );
  }
}

class _ListRequiredFriend extends StatefulWidget {
  final int id;
  final Function(int? id, String currentType)? onActionCallback;

  const _ListRequiredFriend({
    required this.id,
    this.onActionCallback,
  });

  @override
  State<_ListRequiredFriend> createState() => _ListRequiredFriendState();
}

class _ListRequiredFriendState extends State<_ListRequiredFriend> with LoadingMixin {
  late SettingStore _settingStore;
  late BPMemberRequiredFriendStore _memberStore;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);

    _memberStore = BPMemberRequiredFriendStore(_settingStore.requestHelper, page: 1, perPage: 10, id: widget.id)
      ..getMembers();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _memberStore.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients || _memberStore.loading || !_memberStore.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold;

    if (thresholdReached) {
      _memberStore.getMembers();
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(
      builder: (_) {
        bool loading = _memberStore.loading;
        List<BPMember> users = _memberStore.members;
        List<BPMember> emptyMember = List.generate(_memberStore.perPage, (index) => BPMember()).toList();

        List<BPMember> data = loading && users.isEmpty ? emptyMember : users;
        return CustomScrollView(
          controller: _controller,
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: _memberStore.refresh,
              builder: buildAppRefreshIndicator,
            ),
            if (data.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (_, index) => MemberItemWidget(
                      member: data[index],
                      enableRequiredItem: true,
                      onActionCallback: (int? id, String slug) {
                        _memberStore.onChanged(members: changeMemberFriendSlug(users, {
                          id?? 0: slug,
                        }, "awaiting_response"));
                        widget.onActionCallback?.call(id, slug);
                      },
                      // onActionCallback: _memberStore.refresh,
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
            if (loading && users.isNotEmpty)
              SliverToBoxAdapter(
                child: buildLoading(context, isLoading: _memberStore.canLoadMore),
              ),
          ],
        );
      },
    );
  }
}
