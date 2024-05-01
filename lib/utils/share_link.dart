import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

Future<void> shareLink({
  String? name,
  required String permalink,
  required BuildContext context,
  DynamicLink? dynamicLink,
}) async {
  ThemeData theme = Theme.of(context);
  Uri uri;

  if (dynamicLink != null) {
    // Creates a Dynamic Link from the parameters.
    try {
      if (dynamicLink.dynamicLinkType == 'short_link') {
        uri = await dynamicLink.dynamicShortLink();
      } else {
        uri = await dynamicLink.dynamicLongLink();
      }
      Share.share('$uri', subject: name);
    } catch (e) {
      SnackBar snackBar = SnackBar(
        backgroundColor: theme.colorScheme.error,
        content: Text('$e'),
      );
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
      avoidPrint(e);
    }
  } else {
    // Default sharing
    Share.share(permalink, subject: name);
  }
}
