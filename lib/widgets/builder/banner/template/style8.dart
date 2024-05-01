import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class Style8Item extends StatelessWidget with Utility {
  final Map<String, dynamic>? item;
  final Size size;
  final Color background;
  final double? radius;
  final Function(Map<String, dynamic>? action) onClick;
  final String languageKey;
  final String themeModeKey;
  final String imageKey;

  Style8Item({
    Key? key,
    required this.item,
    required this.onClick,
    required this.languageKey,
    required this.themeModeKey,
    required this.imageKey,
    this.size = const Size(375, 330),
    this.background = Colors.transparent,
    this.radius = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    dynamic image = get(item, ['image'], '');
    BoxFit fit = ConvertData.toBoxFit(get(item, ['imageSize'], 'cover'));
    Map<String, dynamic>? action = get(item, ['action'], {});

    String? linkImage = ConvertData.imageFromConfigs(image, imageKey);

    dynamic leading = get(item, ['text1'], {});
    dynamic title = get(item, ['text2'], {});
    dynamic trailing = get(item, ['text3'], {});

    String textLeading = ConvertData.textFromConfigs(leading, languageKey);
    String textTitle = ConvertData.textFromConfigs(title, languageKey);
    String textTrailing = ConvertData.textFromConfigs(trailing, languageKey);

    TextStyle leadingStyle = ConvertData.toTextStyle(leading, themeModeKey);
    TextStyle titleStyle = ConvertData.toTextStyle(title, themeModeKey);
    TextStyle trailingStyle = ConvertData.toTextStyle(trailing, themeModeKey);

    String? typeAction = get(action, ['type'], 'none');

    return Container(
      width: size.width,
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(radius!)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: ImageAlignmentItem(
        image: CirillaCacheImage(
          linkImage,
          width: size.width,
          height: size.height,
          fit: fit,
        ),
        title: Padding(
          padding: secondPaddingVerticalTiny,
          child: Text(
            textTitle,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal, fontSize: 35).merge(titleStyle),
          ),
        ),
        trailing: Container(
          alignment: Alignment.centerRight,
          child: Text(
            textTrailing,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal).merge(trailingStyle),
            textAlign: TextAlign.right,
          ),
        ),
        leading: Text(
          textLeading,
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal).merge(leadingStyle),
        ),
        padding: secondPaddingVerticalSmall.copyWith(top: 15, bottom: 15),
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        width: size.width,
        onTap: () => typeAction != 'none' ? onClick(action) : null,
      ),
    );
  }
}
