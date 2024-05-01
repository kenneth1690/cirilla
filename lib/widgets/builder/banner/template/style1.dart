import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class Style1Item extends StatelessWidget with Utility {
  final Map<String, dynamic>? item;
  final Size size;
  final Color background;
  final double? radius;
  final Function(Map<String, dynamic>? action) onClick;
  final String languageKey;
  final String themeModeKey;
  final String imageKey;

  Style1Item({
    Key? key,
    required this.item,
    required this.onClick,
    this.size = const Size(375, 330),
    this.background = Colors.transparent,
    this.radius,
    required this.languageKey,
    required this.themeModeKey,
    required this.imageKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    dynamic image = get(item, ['image'], '');
    bool enableButton = get(item, ['enableButton'], true);
    BoxFit fit = ConvertData.toBoxFit(get(item, ['imageSize'], 'cover'));

    dynamic title = get(item, ['text1'], {});
    dynamic subTitle = get(item, ['text2'], {});
    dynamic button = get(item, ['textButton'], {});
    Map<String, dynamic>? action = get(item, ['action'], {});

    String? linkImage = ConvertData.imageFromConfigs(image, imageKey);

    String textTitle = ConvertData.textFromConfigs(title, languageKey);
    String textSubTitle = ConvertData.textFromConfigs(subTitle, languageKey);
    String textButton = ConvertData.textFromConfigs(button, languageKey);

    TextStyle titleStyle = ConvertData.toTextStyle(title, themeModeKey);
    TextStyle subtitleStyle = ConvertData.toTextStyle(subTitle, themeModeKey);
    TextStyle buttonStyle = ConvertData.toTextStyle(button, themeModeKey);

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
        title: textTitle.isNotEmpty
            ? Text(
                textTitle,
                style: theme.textTheme.bodyLarge?.merge(titleStyle),
                textAlign: TextAlign.center,
              )
            : null,
        subTitle: Text(
          textSubTitle,
          style: theme.textTheme.bodyLarge?.merge(subtitleStyle),
          textAlign: TextAlign.center,
        ),
        footer: enableButton
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: layoutPadding, vertical: 5),
                color: buttonStyle.backgroundColor ?? Colors.black,
                child: Text(
                  textButton,
                  style: theme.textTheme.bodyLarge?.merge(buttonStyle),
                ),
              )
            : Container(),
        width: size.width,
        onTap: () => typeAction != 'none' ? onClick(action) : null,
      ),
    );
  }
}
