import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../stores/stores.dart';

class ChatSendFieldWidget extends StatelessWidget with ShapeMixin {
  final List<BPMember> users;
  final ValueChanged<List<BPMember>> onchangeUser;

  const ChatSendFieldWidget({
    super.key,
    this.users = const [],
    required this.onchangeUser,
  });

  void onDelete(BPMember user) {
    if (users.contains(user)) {
      onchangeUser(users.where((e) => e.id != user.id).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(translate("buddypress_chat_message_send"), style: theme.inputDecorationTheme.labelStyle),
            TextButton(
              onPressed: () async {
                List<BPMember>? data = await showModalBottomSheet<List<BPMember>?>(
                  isScrollControlled: true,
                  context: context,
                  shape: borderRadiusTop(),
                  builder: (context) {
                    MediaQueryData mediaQuery = MediaQuery.of(context);
                    double height = mediaQuery.size.height - mediaQuery.viewInsets.bottom;

                    return Container(
                      constraints: BoxConstraints(maxHeight: height - 100),
                      padding: const EdgeInsets.only(top: 24),
                      margin: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
                      child: SizedBox(
                        width: double.infinity,
                        child: _ModalUser(
                          dataSelected: users,
                          onSave: (List<BPMember> value) {
                            Navigator.pop(context, value.isNotEmpty ? value : null);
                          },
                        ),
                      ),
                    );
                  },
                );
                if (data != null) {
                  onchangeUser([...users, ...data]);
                }
              },
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
              child: Text(translate("buddypress_chat_message_send_add")),
            ),
          ],
        ),
        if (users.isNotEmpty)
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, int index) {
                BPMember user = users[index];
                return SizedBox(
                  height: 34,
                  child: InputChip(
                    label: Text("@${user.mentionName}"),
                    labelPadding: EdgeInsets.zero,
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 10, 0),
                    labelStyle: theme.textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w500, color: theme.textTheme.titleMedium?.color),
                    side: BorderSide(width: 2, color: theme.dividerColor),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    onDeleted: () => onDelete(user),
                    onPressed: () => onDelete(user),
                    deleteButtonTooltipMessage: translate("buddypress_chat_message_send_delete"),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: users.length,
            ),
          ),
      ],
    );
  }
}

class _ModalUser extends StatefulWidget with Utility {
  final List<BPMember> dataSelected;
  final Function(List<BPMember> data)? onSave;

  const _ModalUser({
    Key? key,
    this.dataSelected = const [],
    this.onSave,
  }) : super(key: key);
  @override
  State<_ModalUser> createState() => _ModalUserState();
}

class _ModalUserState extends State<_ModalUser> with LoadingMixin {
  late SettingStore _settingStore;
  late BPMemberStore _memberStore;
  final List<BPMember> _data = [];

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingStore = Provider.of<SettingStore>(context);
    _memberStore = BPMemberStore(_settingStore.requestHelper, exclude: widget.dataSelected)..getMembers();
  }

  @override
  void dispose() {
    _memberStore.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients || _memberStore.loading || !_memberStore.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold - 100;
    if (thresholdReached) {
      _memberStore.getMembers();
    }
  }

  void _onClick(BPMember user) {
    bool isSelect = _data.contains(user);
    setState(() {
      if (isSelect) {
        _data.remove(user);
      } else {
        setState(() {
          _data.add(user);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(
      builder: (_) {
        bool loading = _memberStore.loading;
        List<BPMember> emptyMember = List.generate(_memberStore.perPage, (index) => BPMember()).toList();

        List<BPMember> data = loading && _memberStore.members.isEmpty ? emptyMember : _memberStore.members;
        return Column(
          children: [
            Text(translate("buddypress_members"), style: Theme.of(context).textTheme.titleMedium),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: TextFormField(
                initialValue: _memberStore.search,
                onChanged: (value) {
                  _memberStore.onChanged(search: value);
                },
                decoration: InputDecoration(hintText: translate("buddypress_search")),
              ),
            ),
            Expanded(
              child: CustomScrollView(
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
                              (_, index) {
                            BPMember user = data[index];
                            if (user.id == null) {
                              return CirillaTile(
                                title: CirillaShimmer(
                                  child: Container(
                                    height: 16,
                                    width: 190,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                                ),
                                isChevron: false,
                              );
                            }
                            bool isSelect = _data.contains(user);
                            return CirillaTile(
                              leading: CirillaRadio.iconCheck(
                                isSelect: isSelect,
                              ),
                              title: Text(user.name ?? "User"),
                              isChevron: false,
                              onTap: () => _onClick(user),
                            );
                          },
                          childCount: data.length,
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      sliver: SliverToBoxAdapter(
                        child: Center(
                          child: Text(translate("buddypress_empty")),
                        ),
                      ),
                    ),
                  if (loading && _memberStore.members.isNotEmpty)
                    SliverToBoxAdapter(
                      child: buildLoading(context, isLoading: _memberStore.canLoadMore),
                    ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: ElevatedButton(
                onPressed: () => widget.onSave?.call(_data),
                child: Text(translate("buddypress_chat_message_send_add")),
              ),
            )
          ],
        );
      },
    );
  }
}
