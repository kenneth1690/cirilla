import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';


class _Option {
  final String key;
  final String keyText;

  _Option({
    required this.key,
    required this.keyText,
  });
}

List<_Option> _options = [
  _Option(key: "unstick", keyText: "bbpress_create_topic_unstick"),
  _Option(key: "stick", keyText: "bbpress_create_topic_stick"),
  _Option(key: "super", keyText: "bbpress_create_topic_super"),
];

String _getText(String key) {
  _Option? option = _options.firstWhereOrNull((element) => element.key == key);
  return option?.keyText ?? key;
}

class TopicTypeFieldWidget extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const TopicTypeFieldWidget({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<TopicTypeFieldWidget> createState() => _TopicTypeFieldWidgetState();
}

class _TopicTypeFieldWidgetState extends State<TopicTypeFieldWidget> with Utility {
  final _controller = TextEditingController();

  @override
  void didChangeDependencies() {
    _controller.text = AppLocalizations.of(context)!.translate(_getText(widget.value));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  void didUpdateWidget(covariant TopicTypeFieldWidget oldWidget) {
    /// Update only if this widget initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (oldWidget.value != widget.value && _getText(widget.value) != _controller.text) {
        _controller.text = AppLocalizations.of(context)!.translate(_getText(widget.value));
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return TextFormField(
      controller: _controller,
      readOnly: true,
      onTap: () async {
        String? value = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return buildViewModal(
              context,
              child: _ModalOption(
                value: widget.value,
                onChange: (String? value) => Navigator.pop(context, value),
              ),
            );
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
        );
        if (value != null && value != widget.value) {
          widget.onChanged(value);
        }
      },
      decoration: InputDecoration(
        labelText: translate("bbpress_create_topic_type"),
        suffixIcon: const Icon(FeatherIcons.chevronDown, size: 16),
      ),
    );
  }

  Widget buildViewModal(BuildContext context, {Widget? child}) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height - mediaQuery.viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(maxHeight: height - 100),
      padding: paddingHorizontal.add(paddingVerticalLarge),
      margin: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: child,
    );
  }
}

class _ModalOption extends StatelessWidget with Utility {
  final String? value;
  final Function(String? value)? onChange;

  const _ModalOption({
    Key? key,
    this.value,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ListView(
      shrinkWrap: true,
      children: _options
          .map((item) {
        bool isSelected = item.key == value;
        TextStyle? titleStyle = theme.textTheme.titleSmall;
        TextStyle? activeTitleStyle = titleStyle?.copyWith(color: theme.primaryColor);

        return CirillaTile(
          title: Text(AppLocalizations.of(context)!.translate(_getText(item.keyText)), style: isSelected ? activeTitleStyle : titleStyle),
          trailing:
          isSelected ? Icon(FeatherIcons.check, size: 20, color: theme.primaryColor) : null,
          isChevron: false,
          onTap: () => onChange?.call(!isSelected? item.key: null),
        );
      }).toList(),
    );
  }
}
