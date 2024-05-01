import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class Style2Item extends StatelessWidget with Utility {
  final Map<String, dynamic>? item;
  final Size size;
  final Color background;
  final double? radius;
  final Function(Map<String, dynamic>? action) onClick;
  final String languageKey;
  final String themeModeKey;
  final String imageKey;

  Style2Item({
    Key? key,
    required this.item,
    required this.onClick,
    required this.languageKey,
    required this.themeModeKey,
    required this.imageKey,
    this.size = const Size(375, 330),
    this.background = Colors.transparent,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    dynamic image = get(item, ['image'], '');
    BoxFit fit = ConvertData.toBoxFit(get(item, ['imageSize'], 'cover'));
    dynamic title = get(item, ['text1'], {});
    Map<String, dynamic>? action = get(item, ['action'], {});

    String? linkImage = ConvertData.imageFromConfigs(image, imageKey);

    String textTitle = ConvertData.textFromConfigs(title, languageKey);
    TextStyle titleStyle = ConvertData.toTextStyle(title, themeModeKey);

    String? typeAction = get(action, ['type'], 'none');

    return Container(
      width: size.width,
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(radius ?? 0)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: ImageFooterItem(
        image: CirillaCacheImage(
          linkImage,
          width: size.width,
          height: size.height,
          fit: fit,
        ),
        footer: Text(
          textTitle,
          style: theme.textTheme.bodyLarge?.merge(titleStyle),
          textAlign: TextAlign.center,
        ),
        padding: paddingHorizontal.add(secondPaddingVerticalSmall),
        width: size.width,
        onTap: () => typeAction != 'none' ? onClick(action) : null,
      ),
    );
  }
}
