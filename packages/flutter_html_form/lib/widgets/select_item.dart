import 'package:flutter/material.dart';

class SelectItemWidget extends StatelessWidget {
  final bool isSelect;
  final String title;
  final ValueChanged<bool> onChange;
  final bool checkbox;
  final bool titleFirst;

  SelectItemWidget({
    Key? key,
    this.isSelect = false,
    required this.title,
    required this.onChange,
    this.checkbox = false,
    this.titleFirst = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChange(!isSelect),
      child: Row(
        children: [
          if (titleFirst) ...[
            Flexible(child: Text(title)),
            SizedBox(width: 10),
          ],
          if (checkbox) _CheckboxIcon(isSelect: isSelect) else _RadioIcon(isSelect: isSelect),
          if (!titleFirst) ...[SizedBox(width: 10), Expanded(child: Text(title))],
        ],
      ),
    );
  }
}

class SelectItemImageWidget extends StatelessWidget {
  final bool isSelect;
  final String title;
  final String image;
  final ValueChanged<bool> onChange;
  final bool checkbox;
  final double size;

  SelectItemImageWidget({
    Key? key,
    this.isSelect = false,
    required this.title,
    required this.image,
    required this.onChange,
    this.checkbox = false,
    this.size = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () => onChange(!isSelect),
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.08),
                  offset: Offset(0, 4),
                  blurRadius: 24,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    image.isNotEmpty ? image : "https://cdn.rnlab.io/placeholder-416x416.png",
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: isSelect
                          ? Border.all(width: 3, color: theme.primaryColor)
                          : Border.all(color: theme.dividerColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: AlignmentDirectional.topEnd,
                    padding: EdgeInsets.all(10),
                    child: checkbox ? _CheckboxIcon(isSelect: isSelect) : _RadioIcon(isSelect: isSelect),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Text(title, style: isSelect ? theme.textTheme.titleSmall : null, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class SelectItemTileCheckWidget extends StatelessWidget {
  final bool isSelect;
  final String title;
  final ValueChanged<bool> onChange;

  SelectItemTileCheckWidget({
    Key? key,
    this.isSelect = false,
    required this.title,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    TextStyle? titleStyle = theme.textTheme.titleSmall;
    TextStyle? activeTitleStyle = titleStyle?.copyWith(color: theme.primaryColor);

    return InkWell(
      onTap: () => onChange(!isSelect),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.dividerColor))),
        child: Row(
          children: [
            Expanded(child: Text(title, style: isSelect ? activeTitleStyle : titleStyle)),
            if (isSelect) ...[
              SizedBox(width: 12),
              Icon(
                Icons.check,
                color: theme.primaryColor,
                size: 20,
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _RadioIcon extends StatelessWidget {
  final bool isSelect;

  _RadioIcon({
    Key? key,
    this.isSelect = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Color colorItem = theme.dividerColor;
    Color colorActiveItem = Color(0xFF21BA45);
    double widthBorder = isSelect ? 7 : 2;

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(width: widthBorder, color: isSelect ? colorActiveItem : colorItem),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _CheckboxIcon extends StatelessWidget {
  final bool isSelect;

  _CheckboxIcon({
    Key? key,
    this.isSelect = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color colorItem = theme.dividerColor;
    Color colorActiveItem = Color(0xFF21BA45);
    Color? background = isSelect ? colorActiveItem : null;

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: background,
        border: Border.all(width: 2, color: isSelect ? colorActiveItem : colorItem),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: isSelect ? Icon(Icons.check, size: 16, color: Colors.white) : null,
    );
  }
}
