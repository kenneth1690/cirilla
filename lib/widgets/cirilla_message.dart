import 'package:awesome_icons/awesome_icons.dart';
import 'package:cirilla/extension/strings.dart';
import 'package:flutter/material.dart';

import '../constants/styles.dart';

enum CirillaMessageType { info, error, success }

class CirillaMessage extends StatelessWidget {
  final String message;
  final CirillaMessageType type;

  const CirillaMessage({
    super.key,
    required this.message,
    this.type = CirillaMessageType.info,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    late IconData icon;
    late Color backgroundColor;
    late Color textColor;

    switch (type) {
      case CirillaMessageType.error:
        icon = FontAwesomeIcons.exclamationCircle;
        textColor = theme.colorScheme.onError;
        backgroundColor = theme.colorScheme.error;
        break;
      case CirillaMessageType.success:
        icon = FontAwesomeIcons.solidCheckCircle;
        textColor = Colors.white;
        backgroundColor = Colors.green;
        break;
      default:
        icon = FontAwesomeIcons.infoCircle;
        textColor = theme.colorScheme.onSurface;
        backgroundColor = theme.colorScheme.surface;
    }

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: layoutPadding, vertical: itemPaddingMedium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: itemPaddingSmall),
          Expanded(
            child: Text(
              message.decodeHtml,
              style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
