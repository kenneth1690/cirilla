import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class BuddyMemberWidget extends StatefulWidget {
  final String? id;
  final dynamic dataJson;
  final Map<String, dynamic>? styles;

  const BuddyMemberWidget({
    Key? key,
    this.id,
    this.dataJson,
    this.styles,
  }) : super(key: key);

  @override
  State<BuddyMemberWidget> createState() => _BuddyMemberWidgetState();
}

class _BuddyMemberWidgetState extends State<BuddyMemberWidget> with Utility, ContainerMixin, LoadingMixin {
  late AppStore _appStore;

  late AuthStore _authStore;
  late SettingStore _settingStore;

  late BPMemberStore _memberStore;

  @override
  void didChangeDependencies() {
    _appStore = Provider.of<AppStore>(context);
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);

    // Filter
    int dataPerPage = ConvertData.stringToInt(get(widget.dataJson, ['perPage'], '4'));
    int dataPage = ConvertData.stringToInt(get(widget.dataJson, ['page'], '1'));
    String? initFilter = get(widget.dataJson, ["initFilter"], "active");
    bool enableSelf = ConvertData.toBoolValue(get(widget.dataJson, ['enableSelf'])) ?? true;

    List<BPMember>? exclude = enableSelf ? null : _authStore.user?.id != null ? [BPMember(id: ConvertData.stringToInt(_authStore.user?.id))]: null;

    String? keyExclude = exclude?.map((m) => "${m.id}").join('_');

    String key = "${widget.id}_buddypress_members_user=${_authStore.user?.id}_perPage=${dataPerPage}_page=$dataPage${keyExclude?.isNotEmpty == true ? "_exclude=$keyExclude": ""}_type=$initFilter";

    int perPage = dataPerPage > 0 ? dataPerPage : 4;
    int page = dataPage > 0 ? dataPage : 1;

    // Add store to list store
    if (_appStore.getStoreByKey(key) == null) {
      BPMemberStore store = BPMemberStore(
        _settingStore.requestHelper,
        key: key,
        perPage: perPage,
        page: page,
        exclude: exclude,
        type: initFilter,
      )..getMembers();
      _appStore.addStore(store);
      _memberStore = store;
    } else {
      _memberStore = _appStore.getStoreByKey(key);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    // Styles
    Map<String, dynamic>? styles = widget.styles;
    Map<String, dynamic>? margin = get(styles, ['margin'], {});
    Map<String, dynamic>? padding = get(styles, ['padding'], {});
    Color background = ConvertData.fromRGBA(get(styles, ['background', _settingStore.themeModeKey], {}), Colors.transparent);
    Color textColor =
    ConvertData.fromRGBA(get(styles, ['textColor', _settingStore.themeModeKey], {}), theme.textTheme.bodyLarge?.color);
    Color subtextColor =
    ConvertData.fromRGBA(get(styles, ['subtextColor', _settingStore.themeModeKey], {}), theme.textTheme.bodyLarge?.color);
    Color dividerColor = ConvertData.fromRGBA(get(styles, ['dividerColor', _settingStore.themeModeKey], {}), theme.dividerColor);

    Color backgroundInput =
    ConvertData.fromRGBA(get(styles, ['backgroundColorInput', _settingStore.themeModeKey], {}), theme.colorScheme.surface);
    Color borderColor = ConvertData.fromRGBA(get(styles, ['borderColorInput', _settingStore.themeModeKey], {}), theme.dividerColor);
    Color iconColor = ConvertData.fromRGBA(get(styles, ['iconColorInput', _settingStore.themeModeKey], {}), theme.textTheme.titleMedium?.color);

    bool enableLoadMore = ConvertData.toBoolValue(get(widget.dataJson, ['loadMore'])) ?? false;
    bool showSearch = ConvertData.toBoolValue(get(widget.dataJson, ['showSearch'])) ?? false;

    return Container(
      margin: ConvertData.space(margin, 'margin'),
      padding: ConvertData.space(padding, 'padding'),
      decoration: decorationColorImage(color: background),
      child: Observer(builder: (_) {
        bool loading = _memberStore.loading;
        List<BPMember> members = _memberStore.members;
        List<BPMember> emptyMember = List.generate(_memberStore.perPage, (index) => BPMember()).toList();
        List<BPMember> data = loading && members.isEmpty ? emptyMember : members;

        return Column(
          children: [
            if (showSearch) ...[
              SearchWidget(
                initialValue: _memberStore.search,
                onChanged: (value) {
                  _memberStore.onChanged(search: value);
                },
                backgroundColor: backgroundInput,
                borderColor: borderColor,
                iconColor: iconColor,
              ),
              const SizedBox(height: 8),
            ],
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: data
                  .map((e) => MemberItemWidget(
                member: e,
                textColor: textColor,
                subtextColor: subtextColor,
                dividerColor: dividerColor,
                onActionCallback: (int? id, String slug) => _memberStore.onChanged(
                  members: changeMemberFriendSlug(_memberStore.members, {id?? 0: slug}, "all"),
                ),
              ),
              ).toList(),
            ),
            if (enableLoadMore && _memberStore.canLoadMore && members.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 34,
                width: 140,
                child: ElevatedButton(
                  onPressed: _memberStore.loading && members.isNotEmpty ? () {} : _memberStore.getMembers,
                  child: loading && members.isNotEmpty ? entryLoading(context, size: 14, color: Colors.white) : Text(translate('load_more')),
                ),
              ),
            ]
          ],
        );
      }),
    );
  }
}
