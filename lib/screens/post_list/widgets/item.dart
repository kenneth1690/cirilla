import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_post_item.dart';
import 'package:flutter/material.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:provider/provider.dart';

class ItemPost extends StatelessWidget with Utility {
  final int index;
  final Post? post;
  final Map? template;
  final Map<String, dynamic>? styles;
  final double width;

  const ItemPost({
    Key? key,
    this.index = 0,
    this.post,
    this.template,
    this.styles,
    this.width = 300,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    SettingStore settingStore = Provider.of<SettingStore>(context);
    String themeModeKey = settingStore.themeModeKey;

    String typeTemplate = get(template, ['template'], Strings.postItemDefault);
    Map<String, dynamic>? dataTemplate = get(template, ['data']);

    double pad = ConvertData.stringToDouble(get(styles, ['pad'], 40));
    double dividerHeight = ConvertData.stringToDouble(get(styles, ['dividerWidth'], 1));
    Color dividerColor = ConvertData.fromRGBA(get(styles, ['dividerColor', themeModeKey], {}), theme.dividerColor);

    Color backgroundColor = ConvertData.fromRGBA(
      get(styles, ['backgroundColorItem', themeModeKey], {}),
      Colors.transparent,
    );
    Color textColor = ConvertData.fromRGBA(
      get(styles, ['textColor', themeModeKey], {}),
      theme.textTheme.titleMedium?.color,
    );
    Color subTextColor = ConvertData.fromRGBA(
      get(styles, ['subTextColor', themeModeKey], {}),
      theme.textTheme.bodySmall?.color,
    );
    Color labelColor = ConvertData.fromRGBA(get(styles, ['labelColor', themeModeKey], {}), ColorBlock.green);
    Color labelTextColor = ConvertData.fromRGBA(get(styles, ['labelTextColor', themeModeKey], {}), Colors.white);
    double? labelRadius = ConvertData.stringToDouble(get(styles, ['labelRadius'], 19));
    BorderRadius radius = ConvertData.corn(get(styles, ['radius'], 0));
    double? radiusImage =
        get(styles, ['radiusImage'], null) == null ? null : ConvertData.stringToDouble(get(styles, ['radiusImage'], 8));
    Map valuePaddingContent = get(styles, ['paddingContent'], {});
    EdgeInsetsDirectional? paddingContent = valuePaddingContent.isNotEmpty
        ? ConvertData.space(valuePaddingContent, 'paddingContent', const EdgeInsetsDirectional.only(top: 8))
        : null;
    Color shadowColor = ConvertData.fromRGBA(get(styles, ['shadowColor', themeModeKey], {}), Colors.transparent);
    double offsetX = ConvertData.stringToDouble(get(styles, ['offsetX'], 0));
    double offsetY = ConvertData.stringToDouble(get(styles, ['offsetY'], 4));
    double blurRadius = ConvertData.stringToDouble(get(styles, ['blurRadius'], 24));
    double spreadRadius = ConvertData.stringToDouble(get(styles, ['spreadRadius'], 0));
    BoxShadow shadow = BoxShadow(
      color: shadowColor,
      offset: Offset(offsetX, offsetY),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
    );

    String? alignment = get(dataTemplate, ['alignment'], 'left');
    double widthSize = ConvertData.stringToDouble(get(dataTemplate, ['size', 'width']), 100);
    double heightSize = ConvertData.stringToDouble(get(dataTemplate, ['size', 'height']), 100);

    return Column(
      children: [
        CirillaPostItem(
          post: post,
          number: index + 1,
          template: typeTemplate,
          dataTemplate: dataTemplate,
          widthItem: width,
          width: widthSize,
          height: heightSize,
          background: backgroundColor,
          textColor: textColor,
          subTextColor: subTextColor,
          labelColor: labelColor,
          labelTextColor: labelTextColor,
          labelRadius: labelRadius,
          radius: radius,
          radiusImage: radiusImage,
          paddingContent: paddingContent,
          boxShadow: [shadow],
          isRightImage: (alignment == 'zigzag' && index % 2 == 1) || alignment == 'right',
        ),
        Divider(
          height: pad,
          thickness: dividerHeight,
          color: dividerColor,
        ),
      ],
    );
  }
}
