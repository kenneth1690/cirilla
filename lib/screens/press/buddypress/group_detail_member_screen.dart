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

class BPMemberGroupDetailMemberScreen extends StatefulWidget {
  final BPGroup? group;

  const BPMemberGroupDetailMemberScreen({
    super.key,
    this.group,
  });

  @override
  State<BPMemberGroupDetailMemberScreen> createState() => _BPMemberGroupDetailMemberScreenState();
}

class _BPMemberGroupDetailMemberScreenState extends State<BPMemberGroupDetailMemberScreen> with AppBarMixin, LoadingMixin {
  late SettingStore _settingStore;
  late BPMemberGroupStore _memberStore;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _settingStore = Provider.of<SettingStore>(context);

    _memberStore = BPMemberGroupStore(_settingStore.requestHelper, idGroup: widget.group?.id)..getMemberGroups();
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
      _memberStore.getMemberGroups();
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Scaffold(
      appBar: baseStyleAppBar(context, title: translate("buddypress_members")),
      body: Observer(
        builder: (_) {
          bool loading = _memberStore.loading;
          List<BPMemberGroup> members = _memberStore.members;
          List<BPMemberGroup> emptyMember = List.generate(_memberStore.perPage, (index) => BPMemberGroup()).toList();

          List<BPMemberGroup> data = loading && members.isEmpty ? emptyMember : members;
          return CustomScrollView(
            controller: _controller,
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: _memberStore.refresh,
                builder: buildAppRefreshIndicator,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: SearchWidget(
                    initialValue: _memberStore.search,
                    onChanged: (value) => _memberStore.onChanged(search: value),
                  ),
                ),
              ),
              if (data.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (_, index) => MemberGroupItemWidget(member: data[index]),
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
              if (loading && members.isNotEmpty)
                SliverToBoxAdapter(
                  child: buildLoading(context, isLoading: _memberStore.canLoadMore),
                ),
            ],
          );
        },
      ),
    );
  }
}
