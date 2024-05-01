import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

import 'get_field.dart';
import 'validate_field.dart';

class AddressFieldPassword extends StatefulWidget {
  final String? value;
  final ValueChanged<String> onChanged;
  final bool borderFields;
  final Map<String, dynamic> field;

  const AddressFieldPassword({
    Key? key,
    this.value,
    this.borderFields = false,
    required this.onChanged,
    required this.field,
  }) : super(key: key);

  @override
  State<AddressFieldPassword> createState() => _AddressFieldPassword();
}

class _AddressFieldPassword extends State<AddressFieldPassword> with Utility {
  bool _obscureText = true;
  final _txtInputText = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    getText();
    _txtInputText.addListener(_onChanged);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AddressFieldPassword oldWidget) {
    /// Update only if this widget initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (oldWidget.value != widget.value && widget.value != _txtInputText.text) {
        getText();
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _txtInputText.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void getText() {
    String defaultValue = get(widget.field, ['default'], '');
    _txtInputText.text = widget.value ?? defaultValue;
  }


  /// Save data in current state
  ///
  _onChanged() {
    if (_txtInputText.text != widget.value) {
      widget.onChanged(_txtInputText.text);
    }
  }

  void _updateObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
    if (_focusNode.hasFocus == false) {
      _focusNode.unfocus();
      _focusNode.canRequestFocus = false;
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
      controller: _txtInputText,
      focusNode: _focusNode,
      validator: (String? value) =>
          validateField(translate: translate, validate: validate, requiredInput: requiredInput, value: value),
      decoration: widget.borderFields == true
          ? InputDecoration(
              labelText: labelText,
              hintText: placeholder,
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
              suffixIcon: IconButton(
                iconSize: 16,
                icon: Icon(_obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                onPressed: _updateObscure,
              ),
            )
          : InputDecoration(
              labelText: labelText,
              hintText: placeholder,
              suffixIcon: IconButton(
                iconSize: 16,
                icon: Icon(_obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                onPressed: _updateObscure,
              ),
            ),
      obscureText: _obscureText,
    );
  }
}
