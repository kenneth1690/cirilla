import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

abstract class AppBarMixin {
  Widget leading({Color? color, String? pop, bool enableIconClose = false}) {
    return Builder(
      builder: (BuildContext context) {
        final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
        final bool canPop = parentRoute?.canPop ?? false;
        if (canPop) {
          return iconButtonLeading(
            color: color,
            onPressed: () {
              Navigator.of(context).pop(pop ?? 'pop');
            },
            enableIconClose: enableIconClose,
          );
        }
        return Container();
      },
    );
  }

  Widget iconButtonLeading({Color? color, required VoidCallback onPressed, bool  enableIconClose = false}) {
    return IconButton(
      tooltip: 'Back',
      icon: Icon(
        enableIconClose ? FeatherIcons.x: FeatherIcons.chevronLeft,
        size: 22,
        color: color,
      ),
      onPressed: onPressed,
    );
  }

  Widget leadingPined({bool  enableIconClose = false}) {
    return Builder(
      builder: (BuildContext context) {
        return Ink(
            width: 38.0,
            height: 38.0,
            decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.backgroundColor!.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: iconButtonLeading(
              enableIconClose: enableIconClose,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),);
      },
    );
  }

  Widget leadingButton({IconData? icon, Function? onPress}) {
    return Builder(
      builder: (BuildContext context) {
        return Ink(
          width: 38.0,
          height: 38.0,
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor!.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              icon,
              size: 20,
            ),
            onPressed: onPress as void Function()?,
          ),
        );
      },
    );
  }

  AppBar baseStyleAppBar(
    BuildContext context,
    {
      required String title,
      bool automaticallyImplyLeading = true,
      List<Widget>? actions,
      bool enableIconClose = false,
    }
  ) {
    return AppBar(
      shadowColor: Colors.transparent,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      leading: automaticallyImplyLeading ? leading(enableIconClose: enableIconClose) : null,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: true,
      title: Text(
        title,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      actions: actions,
    );
  }
}
