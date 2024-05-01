import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class Style2 extends StatelessWidget with Utility {
  final Map<String, dynamic>? item;
  final ShapeBorder shape;
  final Color? color;
  final String languageKey;
  final String themeModeKey;
  final String imageKey;

  Style2({
    Key? key,
    required this.item,
    this.shape = const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
    this.color,
    required this.languageKey,
    required this.themeModeKey,
    required this.imageKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    dynamic image = get(item, ['image'], {});

    dynamic title = get(item, ['title'], {});
    dynamic subtitle = get(item, ['subtitle'], {});
    dynamic description = get(item, ['description'], {});
    bool enableRating = get(item, ['enableRating'], true);
    dynamic rating = get(item, ['rating'], 0);

    String? linkImage = ConvertData.imageFromConfigs(image, imageKey);
    double? valueRating = ConvertData.stringToDouble(rating);

    String textTitle = ConvertData.textFromConfigs(title, languageKey);
    String textSubtitle = ConvertData.textFromConfigs(subtitle, languageKey);
    String textDescription = ConvertData.textFromConfigs(description, languageKey);

    TextStyle titleStyle = ConvertData.toTextStyle(title, themeModeKey);
    TextStyle subtitleStyle = ConvertData.toTextStyle(subtitle, themeModeKey);
    TextStyle descriptionStyle = ConvertData.toTextStyle(description, themeModeKey);

    return TestimonialHorizontalItem(
      image: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: CirillaCacheImage(linkImage, width: 60, height: 60),
      ),
      title: Text(
        textTitle,
        style: theme.textTheme.bodyLarge?.merge(titleStyle),
      ),
      description: Text(
        textDescription,
        style: theme.textTheme.bodyLarge?.merge(descriptionStyle),
      ),
      subtitle: Text(
        textSubtitle,
        style: theme.textTheme.bodyLarge?.merge(subtitleStyle),
      ),
      rating: enableRating ? CirillaRating(value: valueRating) : null,
      width: 310,
      color: color,
      shape: shape,
    );
  }
}
