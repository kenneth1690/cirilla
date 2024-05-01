import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class BuddyActivityWidget extends StatefulWidget {
  final String? id;
  final dynamic dataJson;
  final Map<String, dynamic>? styles;

  const BuddyActivityWidget({
    Key? key,
    this.id,
    this.dataJson,
    this.styles,
  }) : super(key: key);

  @override
  State<BuddyActivityWidget> createState() => _BuddyActivityWidgetState();
}

class _BuddyActivityWidgetState extends State<BuddyActivityWidget> with Utility, ContainerMixin, LoadingMixin {
  late AppStore _appStore;
  late BPActivityStore _activityStore;
  late SettingStore _settingStore;
  late AuthStore _authStore;

  @override
  void didChangeDependencies() {
    _appStore = Provider.of<AppStore>(context);
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);

    // Filter
    int dataPerPage = ConvertData.stringToInt(get(widget.dataJson, ['perPage'], '4'));
    int dataPage = ConvertData.stringToInt(get(widget.dataJson, ['page'], '1'));
    String? initFilter = get(widget.dataJson, ["initFilter"]);
    bool enableSelf = ConvertData.toBoolValue(get(widget.dataJson, ['enableSelf'])) ?? false;

    String key =
        "${widget.id}_buddypress_members_perPage=${dataPerPage}_page=${dataPage}_type=${initFilter}_enableSelf=$enableSelf";

    int perPage = dataPerPage > 0 ? dataPerPage : 4;
    int page = dataPage > 0 ? dataPage : 1;

    // Add store to list store
    if (_appStore.getStoreByKey(key) == null) {
      BPActivityStore store = BPActivityStore(
        _settingStore.requestHelper,
        key: key,
        userId:
            enableSelf && _authStore.user?.id.isNotEmpty == true ? ConvertData.stringToInt(_authStore.user?.id) : null,
        perPage: perPage,
        page: page,
        type: initFilter,
      )..getActivities();
      _appStore.addStore(store);
      _activityStore = store;
    } else {
      _activityStore = _appStore.getStoreByKey(key);
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
    Color background =
        ConvertData.fromRGBA(get(styles, ['background', _settingStore.themeModeKey], {}), Colors.transparent);
    Color textColor = ConvertData.fromRGBA(
        get(styles, ['textColor', _settingStore.themeModeKey], {}), theme.textTheme.bodyLarge?.color);
    Color subtextColor = ConvertData.fromRGBA(
        get(styles, ['subtextColor', _settingStore.themeModeKey], {}), theme.textTheme.bodyLarge?.color);
    Color dividerColor =
        ConvertData.fromRGBA(get(styles, ['dividerColor', _settingStore.themeModeKey], {}), theme.dividerColor);

    Color backgroundInput = ConvertData.fromRGBA(
        get(styles, ['backgroundColorInput', _settingStore.themeModeKey], {}), theme.colorScheme.surface);
    Color borderColor =
        ConvertData.fromRGBA(get(styles, ['borderColorInput', _settingStore.themeModeKey], {}), theme.dividerColor);
    Color iconColor = ConvertData.fromRGBA(
        get(styles, ['iconColorInput', _settingStore.themeModeKey], {}), theme.textTheme.titleMedium?.color);

    bool enableLoadMore = ConvertData.toBoolValue(get(widget.dataJson, ['loadMore'])) ?? false;
    bool showSearch = ConvertData.toBoolValue(get(widget.dataJson, ['showSearch'])) ?? false;
    bool showFilter = ConvertData.toBoolValue(get(widget.dataJson, ['showFilter'])) ?? false;

    return Container(
      margin: ConvertData.space(margin, 'margin'),
      padding: ConvertData.space(padding, 'padding'),
      decoration: decorationColorImage(color: background),
      child: Observer(builder: (_) {
        bool loading = _activityStore.loading;
        List<BPActivity> activities = _activityStore.activities;
        List<BPActivity> emptyActivity = List.generate(_activityStore.perPage, (index) => BPActivity()).toList();
        List<BPActivity> data = loading && activities.isEmpty ? emptyActivity : activities;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showFilter) ...[
              ActivityFilterList(
                value: _activityStore.type,
                onChanged: (type) => _activityStore.onChanged(type: type),
                direction: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              const SizedBox(height: 10),
            ],
            if (showSearch) ...[
              SearchWidget(
                initialValue: _activityStore.search,
                onChanged: (value) {
                  _activityStore.onChanged(search: value);
                },
                backgroundColor: backgroundInput,
                borderColor: borderColor,
                iconColor: iconColor,
              ),
              const SizedBox(height: 16),
            ],
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: data
                  .map(
                    (e) => ActivityItemWidget(
                      activity: e,
                      textColor: textColor,
                      subtextColor: subtextColor,
                      dividerColor: dividerColor,
                    ),
                  )
                  .toList(),
            ),
            if (enableLoadMore && _activityStore.canLoadMore && activities.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 34,
                width: 140,
                child: ElevatedButton(
                  onPressed: _activityStore.loading && activities.isNotEmpty ? () {} : _activityStore.getActivities,
                  child: loading && activities.isNotEmpty
                      ? entryLoading(context, size: 14, color: Colors.white)
                      : Text(translate('load_more')),
                ),
              ),
            ]
          ],
        );
      }),
    );
  }
}
