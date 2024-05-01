import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class BuddyGroupWidget extends StatefulWidget {
  final String? id;
  final dynamic dataJson;
  final Map<String, dynamic>? styles;

  const BuddyGroupWidget({
    Key? key,
    this.id,
    this.dataJson,
    this.styles,
  }) : super(key: key);

  @override
  State<BuddyGroupWidget> createState() => _BuddyGroupWidgetState();
}

class _BuddyGroupWidgetState extends State<BuddyGroupWidget> with Utility, ContainerMixin, LoadingMixin {
  late AppStore _appStore;
  late BPGroupStore _groupStore;
  late SettingStore _settingStore;

  @override
  void didChangeDependencies() {
    _appStore = Provider.of<AppStore>(context);
    _settingStore = Provider.of<SettingStore>(context);

    int dataPerPage = ConvertData.stringToInt(get(widget.dataJson, ['perPage'], '4'));
    int dataPage = ConvertData.stringToInt(get(widget.dataJson, ['page'], '1'));
    String? initFilter = get(widget.dataJson, ["initFilter"], "active");

    String key = "${widget.id}__buddypress_groups_perPage=${dataPerPage}_page=${dataPage}_type=$initFilter}";

    int perPage = dataPerPage > 0 ? dataPerPage : 4;
    int page = dataPage > 0 ? dataPage : 1;

    // Add store to list store
    if (_appStore.getStoreByKey(key) == null) {
      BPGroupStore store = BPGroupStore(_settingStore.requestHelper, key: key, perPage: perPage, page: page, type: initFilter)..getGroups();
      _appStore.addStore(store);
      _groupStore = store;
    } else {
      _groupStore = _appStore.getStoreByKey(key);
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
    ConvertData.fromRGBA(get(styles, ['textColor', _settingStore.themeModeKey], {}), theme.textTheme.titleMedium?.color);
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
        bool loading = _groupStore.loading;
        List<BPGroup> groups = _groupStore.groups;
        List<BPGroup> emptyGroup = List.generate(_groupStore.perPage, (index) => BPGroup()).toList();
        List<BPGroup> data = loading && groups.isEmpty ? emptyGroup : groups;

        return Column(
          children: [
            if (showSearch) ...[
              SearchWidget(
                initialValue: _groupStore.search,
                onChanged: (value) {
                  _groupStore.onChanged(search: value);
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
                  .map((e) => GroupItemWidget(
                group: e,
                textColor: textColor,
                subtextColor: subtextColor,
                dividerColor: dividerColor,
              ))
                  .toList(),
            ),
            if (enableLoadMore && _groupStore.canLoadMore && groups.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 34,
                width: 140,
                child: ElevatedButton(
                  onPressed: _groupStore.loading && groups.isNotEmpty ? () {} : _groupStore.getGroups,
                  child: loading && groups.isNotEmpty ? entryLoading(context, size: 14, color: Colors.white) : Text(translate('load_more')),
                ),
              ),
            ]
          ],
        );
      }),
    );
  }
}
