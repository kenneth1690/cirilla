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

import '../utils.dart';
import 'models/models.dart';
import 'stores/stores.dart';
import 'widgets/widgets.dart';

class BPMemberListScreen extends StatefulWidget {
  static const routeName = '/buddypress-member-list';

  final Map? args;
  final SettingStore? store;

  const BPMemberListScreen({
    super.key,
    this.args,
    this.store,
  });

  @override
  State<BPMemberListScreen> createState() => _BPMemberListScreenState();
}

class _BPMemberListScreenState extends State<BPMemberListScreen> with AppBarMixin, LoadingMixin {
  late AuthStore _authStore;
  late BPMemberStore _memberStore;
  final ScrollController _controller = ScrollController();

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
    bool enableSelf = ConvertData.toBoolValue(get(widget.args, ["enableSelf"])) ?? true;
    List<BPMember>? exclude = enableSelf
        ? null
        : _authStore.user?.id != null
            ? [BPMember(id: ConvertData.stringToInt(_authStore.user?.id))]
            : null;

    _memberStore =
        BPMemberStore(widget.store!.requestHelper, page: page, perPage: perPage, exclude: exclude, type: initFilter)
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

  void _onFilter() async {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    List<OptionFilter> options = [
      OptionFilter(key: "active", text: translate("buddypress_last_active")),
      OptionFilter(key: "newest", text: translate("buddypress_newest_register")),
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
                    value: _memberStore.type,
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
    if (value != null && value != _memberStore.type) {
      _memberStore.onChanged(type: value);
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
        title: name?.isNotEmpty == true ? name! : translate("buddypress_member_list"),
        actions: showFilter
            ? [
                IconButton(onPressed: _onFilter, icon: const Icon(FeatherIcons.sliders, size: 20)),
                const SizedBox(width: 12),
              ]
            : null,
      ),
      body: Observer(
        builder: (_) {
          bool loading = _memberStore.loading;
          List<BPMember> users = _memberStore.members;
          List<BPMember> emptyMember = List.generate(_memberStore.perPage, (index) => BPMember()).toList();

          List<BPMember> data = loading && users.isEmpty ? emptyMember : users;
          return CustomScrollView(
            controller: loadMore ? _controller : null,
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: _memberStore.refresh,
                builder: buildAppRefreshIndicator,
              ),
              if (showSearch)
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
                      (_, index) => MemberItemWidget(
                        member: data[index],
                        onActionCallback: (int? id, String slug) => _memberStore.onChanged(
                          members: changeMemberFriendSlug(_memberStore.members, {id?? 0: slug}, "all"),
                        ),
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
              if (loadMore && loading && users.isNotEmpty)
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
