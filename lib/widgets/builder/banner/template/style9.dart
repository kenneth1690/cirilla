import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/cirilla_cache_image.dart';
import 'package:flutter/material.dart';

import 'package:ui/ui.dart';

class Style9Item extends StatelessWidget with Utility {
  final Map<String, dynamic>? item;
  final Size size;
  final Color background;
  final double radius;
  final Function(Map<String, dynamic>? action) onClick;
  final String languageKey;
  final String themeModeKey;
  final String imageKey;

  Style9Item({
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
    dynamic image = get(item, ['image'], '');
    BoxFit fit = ConvertData.toBoxFit(get(item, ['imageSize'], 'cover'));
    String? linkImage = ConvertData.imageFromConfigs(image, imageKey);

    bool enableRoundImage = get(item, ['enableRoundImage'], false);
    double? radiusImage = ConvertData.stringToDouble(get(item, ['radiusImage'], 8));

    dynamic title = get(item, ['text1'], {});

    String textTitle = ConvertData.textFromConfigs(title, languageKey);

    TextStyle titleStyle = ConvertData.toTextStyle(title, themeModeKey);

    TextAlign alignTitle = ConvertData.toTextAlignDirection(get(item, ['alignment'], 'center'));

    Map<String, dynamic>? action = get(item, ['action'], {});

    double radiusViewImage = enableRoundImage
        ? size.width > size.height
            ? size.width / 2
            : size.height / 2
        : radiusImage;

    return Container(
      width: size.width,
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(radius)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: ImageVerticalItem(
        onTap: () => onClick(action),
        image: ClipRRect(
          borderRadius: BorderRadius.circular(radiusViewImage),
          child: CirillaCacheImage(
            linkImage,
            width: size.width,
            height: size.height,
            fit: fit,
          ),
        ),
        title: SizedBox(
          width: double.infinity,
          child: Text(
            textTitle,
            textAlign: alignTitle,
            style: Theme.of(context).textTheme.titleSmall?.merge(titleStyle),
          ),
        ),
      ),
    );
  }
}
