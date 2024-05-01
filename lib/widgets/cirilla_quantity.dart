import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CirillaQuantity extends StatefulWidget {
  final int value;
  final ValueChanged<int>? onChanged;
  final double width;
  final double height;
  final Color? color;
  final Color? borderColor;
  final int min;
  final int? max;
  final Function? actionZero;
  final double? radius;
  final TextStyle? textStyle;
  final int step;

  static const int maxQty = 999;

  const CirillaQuantity({
    Key? key,
    required this.value,
    required this.onChanged,
    this.height = 34,
    this.width = 90,
    this.color,
    this.min = 1,
    this.max,
    this.actionZero,
    this.radius,
    this.borderColor,
    this.textStyle,
    this.step = 1,
  })  : assert(height >= 28),
        assert(width >= 64),
        assert(step > 0),
        super(key: key);

  @override
  State<CirillaQuantity> createState() => _CirillaQuantityState();
}

class _CirillaQuantityState extends State<CirillaQuantity> with ShapeMixin {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: '${widget.value}');
    super.initState();
  }

  void _handleUpdate(int value) {
    if (widget.onChanged != null && mounted) {
      widget.onChanged!.call(value);
    }
  }

  void _handleChanged(String newValue) {
    int qty = ConvertData.stringToInt(newValue, 0);

    // User put input empty
    if (qty == 0) {
      _handleUpdate(widget.value);
      _controller.text = '${widget.value}';
      return;
    }

    // Qty max API support
    if (qty > CirillaQuantity.maxQty) {
      qty = CirillaQuantity.maxQty;
    }

    // User type input over max value
    if (widget.max != null && qty >= widget.max!) {
      qty = widget.max!;
    }

    if ('$qty' != newValue) {
      _controller.text = '$qty';
    }

    _handleUpdate(qty);
  }

  void _onBlur(PointerDownEvent event) {
    if (_controller.text != '${widget.value}') {
      _handleChanged(_controller.text);
    }
    FocusScope.of(context).unfocus();
  }

  void _increase() {
    int qty = ConvertData.stringToInt(_controller.text, widget.min);
    int newQty = ((qty + widget.step) / widget.step).round() * widget.step;
    if (widget.max == null || (widget.max != null && widget.max! >= newQty)) {
      _handleUpdate(newQty);
      _controller.text = '$newQty';
    }
  }

  void _decrease() {
    int qty = ConvertData.stringToInt(_controller.text, widget.min);
    int newQty = ((qty - widget.step) / widget.step).ceil() * widget.step;
    if (widget.min <= newQty) {
      _handleUpdate(newQty);
      _controller.text = '$newQty';
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightItem = widget.height;

    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(widget.radius ?? 4),
        border: widget.borderColor != null ? Border.all(color: widget.borderColor!) : null,
      ),
      height: heightItem,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Row(
        children: [
          buildIconButton(
            onTap: widget.min < widget.value ? _decrease : null,
            icon: Icons.remove_rounded,
          ),
          Expanded(child: buildInput()),
          buildIconButton(
            onTap: widget.max == null || (widget.max != null && widget.max! > widget.value) ? _increase : null,
            icon: Icons.add_rounded,
          ),
        ],
      ),
    );
  }

  Widget buildInput() {
    ThemeData theme = Theme.of(context);
    TextStyle? textStyle =
        theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.titleMedium?.color).merge(widget.textStyle);
    return TextFormField(
      controller: _controller,
      onTapOutside: _onBlur,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: textStyle,
    );
  }

  Widget buildIconButton({
    required IconData icon,
    GestureTapCallback? onTap,
  }) {
    ThemeData theme = Theme.of(context);
    Widget child = Container(
      height: double.infinity,
      width: 32,
      padding: paddingHorizontalTiny,
      child: Icon(
        icon,
        size: 16,
        color: onTap != null ? theme.textTheme.titleMedium?.color : theme.textTheme.bodyMedium?.color,
      ),
    );
    return onTap != null ? InkWell(onTap: onTap, child: child) : child;
  }
}
