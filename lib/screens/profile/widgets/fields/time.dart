import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/profile/widgets/fields/modal_date_time.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'get_field.dart';
import 'validate_field.dart';

class AddressFieldTime extends StatefulWidget {
  final String? value;
  final ValueChanged<String> onChanged;
  final bool borderFields;
  final Map<String, dynamic> field;

  const AddressFieldTime({
    Key? key,
    this.value,
    this.borderFields = false,
    required this.onChanged,
    required this.field,
  }) : super(key: key);

  @override
  State<AddressFieldTime> createState() => _AddressFieldTimeState();
}

class _AddressFieldTimeState extends State<AddressFieldTime> with Utility {
  final _controller = TextEditingController();

  @override
  void initState() {
    String defaultValue = get(widget.field, ['default'], '');
    _controller.text = widget.value ?? defaultValue;
    _controller.addListener(_onChanged);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AddressFieldTime oldWidget) {
    /// Update only if this widget initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (oldWidget.value != widget.value && widget.value != _controller.text) {
        String defaultValue = get(widget.field, ['default'], '');
        _controller.text = widget.value ?? defaultValue;
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Save data in current state
  ///
  _onChanged() {
    if (widget.value != _controller.text) {
      widget.onChanged(_controller.text);
    }
  }

  void selectTime(BuildContext context) async {
    DateTime? dateTime;
    if (_controller.text.isNotEmpty) {
      dateTime = DateFormat("HH:mm").parse(_controller.text);
    }

    DateTime? value = await showModalBottomSheet<DateTime?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return buildViewModal(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter stateSetter) {
              return ModalDateTime(
                value: dateTime,
                onChanged: (DateTime? value) {
                  Navigator.pop(context, value);
                },
                mode: CupertinoDatePickerMode.time,
              );
            },
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
    );
    if (value != null) {
      if (!mounted) return;
      String time = DateFormat('HH:mm').format(value);
      if (time != _controller.text) {
        _controller.text = time;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    String label = get(widget.field, ['label'], '');
    String placeholder = get(widget.field, ['placeholder'], '');
    bool requiredInput = ConvertData.toBoolValue(widget.field["required"]) ?? false;
    List validate = getList(widget.field["validate"]);

    String? labelText = requiredInput ? '$label *' : label;

    return TextFormField(
      controller: _controller,
      readOnly: true,
      validator: (String? value) =>
          validateField(translate: translate, validate: validate, requiredInput: requiredInput, value: value),
      onTap: () => selectTime(context),
      decoration: widget.borderFields == true
          ? InputDecoration(
              labelText: labelText,
              hintText: placeholder,
              suffixIcon: const Padding(
                padding: EdgeInsetsDirectional.only(end: itemPaddingMedium),
                child: Icon(FeatherIcons.clock, size: 16),
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 2,
                minHeight: 2,
              ),
              contentPadding: const EdgeInsetsDirectional.only(start: itemPaddingMedium),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: theme.inputDecorationTheme.border?.borderSide ?? const BorderSide(),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: theme.inputDecorationTheme.enabledBorder?.borderSide ?? const BorderSide(),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: theme.inputDecorationTheme.focusedBorder?.borderSide ?? const BorderSide(),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: theme.inputDecorationTheme.errorBorder?.borderSide ?? const BorderSide(),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: theme.inputDecorationTheme.focusedErrorBorder?.borderSide ?? const BorderSide(),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: theme.inputDecorationTheme.disabledBorder?.borderSide ?? const BorderSide(),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            )
          : InputDecoration(
              labelText: labelText,
              hintText: placeholder,
              suffixIcon: const Icon(FeatherIcons.clock, size: 16),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 2,
                minHeight: 2,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
    );
  }

  Widget buildViewModal({Widget? child}) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      double height = constraints.maxHeight;
      return Container(
        constraints: BoxConstraints(maxHeight: height * 0.7),
        padding: paddingHorizontal.add(paddingVerticalLarge),
        child: SizedBox(
          width: double.infinity,
          child: child,
        ),
      );
    });
  }
}
