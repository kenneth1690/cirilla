import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DefaultCustomWidget extends StatelessWidget with Utility, ContainerMixin {
  final Map<String, dynamic>? styles;
  final Widget? child;

  DefaultCustomWidget({
    Key? key,
    this.child,
    required this.styles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;

    Map<String, dynamic>? margin = get(styles, ['margin'], {});
    Map<String, dynamic>? padding = get(styles, ['padding'], {});
    Map? background = get(styles, ['backgroundColor', themeModeKey], {});

    Color backgroundColor = ConvertData.fromRGBA(background, Colors.transparent);

    Color backgroundInput = ConvertData.fromRGBA(
        get(styles, ['backgroundColorInput', settingStore.themeModeKey], {}), theme.colorScheme.surface);
    Color borderColor =
        ConvertData.fromRGBA(get(styles, ['borderColorInput', settingStore.themeModeKey], {}), theme.dividerColor);
    Color iconColor = ConvertData.fromRGBA(
        get(styles, ['iconColorInput', settingStore.themeModeKey], {}), theme.textTheme.titleMedium?.color);

    return Container(
      margin: ConvertData.space(margin, 'margin'),
      padding: ConvertData.space(padding, 'padding'),
      decoration: decorationColorImage(color: backgroundColor),
      child: Theme(
        data: theme.copyWith(
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
            filled: true,
            fillColor: backgroundInput,
            border: theme.inputDecorationTheme.border?.copyWith(borderSide: BorderSide(color: borderColor)),
            enabledBorder: theme.inputDecorationTheme.border?.copyWith(borderSide: BorderSide(color: borderColor)),
            iconColor: iconColor,
          ),
        ),
        child: Builder(builder: (_) => child ?? Container()),
      ),
    );
  }
}
