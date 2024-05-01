import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class OptionFilter {
  final String key;
  final String text;
  OptionFilter({
    required this.key,
    required this.text,
  });
}

class ModalFilterWidget extends StatelessWidget {
  final String? value;
  final List<OptionFilter> options;
  final ValueChanged<String> onSelected;

  const ModalFilterWidget({super.key, this.value, required this.options, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return Container();
    }
    ThemeData theme = Theme.of(context);

    TextStyle? titleStyle = theme.textTheme.titleSmall;
    TextStyle? activeTitleStyle = titleStyle?.copyWith(color: theme.primaryColor);

    return Column(
      children: options
          .map((e) => CirillaTile(
                title: Text(e.text, style: e.key == value ? activeTitleStyle : titleStyle),
                trailing: e.key == value ? Icon(FeatherIcons.check, size: 20, color: theme.primaryColor) : null,
                isChevron: false,
                onTap: () => onSelected(e.key),
              ))
          .toList(),
    );
  }
}
