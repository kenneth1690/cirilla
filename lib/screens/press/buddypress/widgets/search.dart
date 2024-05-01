import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;

  const SearchWidget({
    super.key,
    this.initialValue,
    this.onChanged,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    InputBorder borderInput = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: borderColor ?? theme.dividerColor, width: 1),
    );

    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundColor ?? theme.colorScheme.surface,
        hintText: translate("buddypress_search"),
        prefixIcon: Icon(FeatherIcons.search, size: 16, color: iconColor ?? theme.textTheme.titleMedium?.color),
        border: borderInput,
        enabledBorder: borderInput,
        disabledBorder: borderInput,
        errorBorder: borderInput,
        focusedBorder: borderInput,
      ),
      onChanged: onChanged,
      textAlignVertical: TextAlignVertical.center,
    );
  }
}