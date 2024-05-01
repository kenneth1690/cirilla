import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class _SearchVisit {
  final String search;
  final int visitStart;
  final int visitEnd;

  _SearchVisit({
    required this.search,
    required this.visitStart,
    required this.visitEnd,
  });
}

class ActivityFormWidget extends StatefulWidget {
  final String? mentionName;
  final int? primaryId;
  final int? secondaryId;
  final Function callback;
  final double? height;

  const ActivityFormWidget({
    super.key,
    this.mentionName,
    this.primaryId,
    this.secondaryId,
    required this.callback,
    this.height,
  });

  @override
  State<ActivityFormWidget> createState() => _ActivityFormWidgetState();
}

class _ActivityFormWidgetState extends State<ActivityFormWidget> with AppBarMixin, LoadingMixin, SnackMixin, ShapeMixin {
  late SettingStore _settingStore;
  late AuthStore _authStore;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _controller;
  late String _content;
  _SearchVisit? _search;
  bool _loading = false;

  @override
  void initState() {
    String text = widget.mentionName?.isNotEmpty == true ? "@${widget.mentionName} " : "";
    _controller = TextEditingController(text: text);
    _content = text;

    _controller.addListener(() {
      String text = _controller.text;
      if (text != _content) {
        int cursorVisit = _controller.selection.baseOffset;

        setState(() {
          _search = getSearch(text, cursorVisit);
          _content = text;
        });
      }
    });
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _SearchVisit? getSearch(String text, int visit) {
    if (text.isNotEmpty) {
      String newText = visit > 0 ? text.substring(0, visit) : text;
      List<String> listText = newText.split(" ");
      if (listText.last.isNotEmpty && listText.last[0] == "@") {
        String search = listText.last.substring(1);
        int visitStart = visit - listText.last.length;
        int visitEnd = visit;
        return _SearchVisit(search: search, visitStart: visitStart, visitEnd: visitEnd);
      }
    }
    return null;
  }

  void selectMember(String member, _SearchVisit search) {
    String text = _controller.text;
    String oldText = text.substring(search.visitStart, search.visitEnd);
    String newText = "@$member ";

    setState(() {
      _controller.text = text.replaceFirst(oldText, newText, search.visitStart);
      _controller.selection =
          TextSelection.collapsed(offset: search.visitStart + newText.length);
      _search = null;
    });
  }

  void _handleCreateActivity(TranslateType translate) async {
    try {
      setState(() {
        _loading = true;
      });
      Map<String, dynamic> data = {
        "context": "edit",
        "user_id": _authStore.user?.id,
        "component": "activity",
        "type": (widget.secondaryId ?? 0) == 0 ? "activity_update" : "activity_comment",
        "content": _controller.text,
        if (widget.primaryId != null) "primary_item_id": widget.primaryId!,
        if (widget.secondaryId != null) "secondary_item_id": widget.secondaryId,
      };
      await _settingStore.requestHelper.createActivity(
        data: data,
      );
      setState(() {
        _loading = false;
      });
      widget.callback();
    } catch (e) {
      setState(() {
        _loading = false;
      });
      if (mounted) showError(context, e);
    }
  }

  Widget buildForm({required ThemeData theme, required TranslateType translate}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CirillaCacheImage(_authStore.user?.avatar, width: 32, height: 32),
                      ),
                      const SizedBox(height: 12),
                      const Expanded(child: VerticalDivider(width: 1, thickness: 1),)
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(_authStore.user?.displayName ?? "", style: theme.textTheme.labelMedium),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _controller,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: translate("buddypress_content"),
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.inputDecorationTheme.hintStyle?.color),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                          ),
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.titleMedium?.color),
                          cursorColor: theme.textTheme.titleMedium?.color,
                          minLines: 1,
                          maxLines: 5,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return translate("buddypress_validate_empty");
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!_loading && _formKey.currentState!.validate()) {
                    _handleCreateActivity(translate);
                  }
                },
                child: _loading
                    ? entryLoading(
                  context,
                  color: theme.colorScheme.onPrimary,
                )
                    : Text(translate("buddypress_post")),
              ),
            )
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    MediaQueryData mediaQuery = MediaQuery.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    int ratioExpand = (widget.height ?? mediaQuery.size.height) ~/ 170;

    return Observer(
      builder: (_) {
        if (_authStore.isLogin) {
          return Column(
            children: [
              Expanded(
                child: buildForm(theme: theme, translate: translate),
              ),
              if (_search != null) ...[
                const Divider(height: 1, thickness: 1),
                Expanded(
                  flex: ratioExpand,
                  child: _ListUser(
                    search: _search!.search,
                    onSelect: (String text) => selectMember(text, _search!),
                  ),
                )
              ]
            ],
          );
        }

        return Container(
            padding: const EdgeInsets.symmetric(vertical: 50),
            width: double.infinity,
            child: Column(
              children: [
                Text(translate("buddypress_required_login")),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed(LoginScreen.routeName),
                  child: Text(translate("buddypress_sign_in")),
                )
              ],
            )
        );
      },
    );
  }
}


class _ListUser extends StatefulWidget with Utility {
  final String search;
  final ValueChanged<String> onSelect;

  const _ListUser({
    Key? key,
    this.search = "",
    required this.onSelect,
  }) : super(key: key);
  @override
  State<_ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<_ListUser> with LoadingMixin {
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
    super.didChangeDependencies();
    _settingStore = Provider.of<SettingStore>(context);
    _memberStore = BPMemberStore(_settingStore.requestHelper, search: widget.search)..getMembers();
  }

  @override
  void dispose() {
    _memberStore.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _ListUser oldWidget) {
    if (oldWidget.search != widget.search) {
      _memberStore.onChanged(
        search: widget.search
      );
    }
    super.didUpdateWidget(oldWidget);
  }
  void _onScroll() {
    if (!_controller.hasClients || _memberStore.loading || !_memberStore.canLoadMore) return;
    final thresholdReached = _controller.position.extentAfter < endReachedThreshold - 100;
    if (thresholdReached) {
      _memberStore.getMembers();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Observer(
      builder: (_) {
        bool loading = _memberStore.loading;
        List<BPMember> emptyMember = List.generate(_memberStore.perPage, (index) => BPMember()).toList();

        List<BPMember> data = loading && _memberStore.members.isEmpty ? emptyMember : _memberStore.members;
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
                        (_, index) {
                      BPMember user = data[index];
                      if (user.id == null) {
                        return CirillaTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CirillaShimmer(
                                child: Container(
                                  height: 14,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ),
                              CirillaShimmer(
                                child: Container(
                                  height: 14,
                                  width: 190,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              )
                            ],
                          ),
                          isChevron: false,
                        );
                      }
                      return CirillaTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(user.mentionName ?? "user", style: theme.textTheme.titleSmall),
                            Text(user.name ?? "User", style: theme.textTheme.bodySmall),
                          ],
                        ),
                        isChevron: false,
                        onTap: () => widget.onSelect(user.mentionName ?? ""),
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
        );
      },
    );
  }
}

