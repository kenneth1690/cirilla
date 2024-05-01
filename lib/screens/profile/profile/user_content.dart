import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/ui.dart';

enum UserContentType { container, emerge, base }

class UserContent extends StatelessWidget with NavigationMixin {
  final User? user;
  final UserContentType type;

  /// for [type = UserContentType.container]
  final Color? backgroundColor;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const UserContent({
    super.key,
    this.user,
    this.type = UserContentType.base,
    this.backgroundColor,
    this.color,
    this.padding,
  });

  void onGoAccount(BuildContext context) {
    Navigator.of(context).pushNamed(AccountScreen.routeName);
  }

  String getAvatar() {
    return user?.socialAvatar?.isNotEmpty == true ? user!.socialAvatar! : user?.avatar ?? '';
  }

  String getName() {
    return user?.displayName ?? "Admin";
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    String avatar = getAvatar();
    String name = getName();

    switch (type) {
      case UserContentType.container:
        return UserContainedItem(
          image: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: CirillaCacheImage(
              avatar,
              width: 60,
              height: 60,
            ),
          ),
          title: Text(
            name,
            style: theme.textTheme.titleSmall?.copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: Text(translate('welcome'), style: theme.textTheme.bodySmall?.copyWith(color: color)),
          padding: padding ?? paddingHorizontalLarge.add(paddingVerticalMedium),
          color: backgroundColor ?? theme.colorScheme.surface,
          onClick: () => onGoAccount(context),
        );
      case UserContentType.emerge:
        return UserEmergeItem(
          image: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              image: DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(avatar.isNotEmpty ? avatar : Assets.noImageUrl)),
              boxShadow: initBoxShadow,
            ),
          ),
          title: Text(
            name,
            style: theme.textTheme.titleMedium,
          ),
          subtitle: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => navigate(context, {
                "type": "logout",
                "route": "/logout",
                "args": {"name": "Logout"}
              }),
              child: Text(translate('side_bar_logout').toUpperCase(), style: Theme.of(context).textTheme.bodySmall),
            ),
          ),
          color: theme.scaffoldBackgroundColor,
          shadow: initBoxShadow,
          emergeHeight: 40,
          onClick: () => onGoAccount(context),
        );
      default:
        return GestureDetector(
          onTap: () => onGoAccount(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: CirillaCacheImage(
                  avatar,
                  width: 36,
                  height: 36,
                ),
              ),
              const SizedBox(width: itemPadding),
              Flexible(child: Text(name)),
            ],
          ),
        );
    }
  }
}

class UserContentEmergeNoGuest extends StatelessWidget with GeneralMixin {
  const UserContentEmergeNoGuest({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    SettingStore settingStore = Provider.of<SettingStore>(context);

    bool enableRegister = getConfig(settingStore, ['enableRegister'], true);

    return UserEmergeItem(
      image: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          image: const DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              Assets.noAvatar,
            ),
          ),
          boxShadow: initBoxShadow,
        ),
      ),
      title: Text(
        translate('side_bar_guest'),
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed(LoginScreen.routeName, arguments: {
                'showMessage': ({String? message}) {
                  avoidPrint('112');
                }
              }),
              child: Text(
                translate(enableRegister ? 'side_bar_login_source' : 'side_bar_login').toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          if (enableRegister)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context).pushNamed(RegisterScreen.routeName, arguments: {
                  'showMessage': ({String? message}) {
                    avoidPrint('112');
                  }
                }),
                child: Text(
                  translate('side_bar_sign_up').toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            )
        ],
      ),
      color: theme.scaffoldBackgroundColor,
      shadow: initBoxShadow,
      emergeHeight: 40,
    );
  }
}
