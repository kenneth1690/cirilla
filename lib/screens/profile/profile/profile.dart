import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/constants/strings.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/screens/profile/widgets/icon_notification.dart';
import 'package:cirilla/screens/search/search_feature.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/utils/conditionals.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'data.dart';

import 'layout_style1.dart';
import 'layout_style2.dart';
import 'layout_style3.dart';
import 'layout_style4.dart';

import 'footer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with Utility {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  late SettingStore _settingStore;
  late AuthStore _authStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);
  }

  void showMessage({String? message}) {
    scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: Colors.green,
        ),
        margin: secondPaddingSmall,
        padding: secondPaddingSmall,
        height: 40,
        child: Center(child: Text(message ?? '')),
      ),
    ));
  }

  dynamic toVariable(String variable) {
    if (variable == "user.id") {
      return _authStore.user?.id ?? "";
    }

    if (variable == "user.displayName") {
      return _authStore.user?.displayName ?? "";
    }

    if (variable == "user.userEmail") {
      return _authStore.user?.userEmail ?? "";
    }

    if (variable == "user.loginType") {
      return _authStore.user?.loginType ?? "";
    }

    if (variable == "user.roles") {
      return _authStore.user?.roles ?? [];
    }

    if (variable == "language") {
      return _settingStore.locale;
    }

    return _authStore.isLogin ? 'true' : 'false';
  }

  List getBlocks(List data) {
    List result = [];
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        dynamic block = data[i];
        dynamic conditional = get(block, ["data", "conditional"], null);
        if (conditional != null && conditional['when_conditionals'] != null && conditional['conditionals'] != null) {
          bool check = conditionalCheck(
            conditional['when_conditionals'],
            conditional['conditionals'],
            [
              "isLogin",
              "language",
              "user.id",
              "user.displayName",
              "user.userEmail",
              "user.loginType",
              "user.roles",
            ],
            toVariable,
          );

          if (check) {
            result.add(block);
          }
        } else {
          result.add(block);
        }
      }
    }
    return result;
  }

  List getItemBlocks(List data) {
    List result = [];
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        dynamic block = data[i];
        dynamic conditional = get(block, ["value", "conditional"], null);
        if (conditional != null && conditional['when_conditionals'] != null && conditional['conditionals'] != null) {
          bool check = conditionalCheck(
            conditional['when_conditionals'],
            conditional['conditionals'],
            [
              "isLogin",
              "language",
              "user.id",
              "user.displayName",
              "user.userEmail",
              "user.loginType",
              "user.roles",
            ],
            toVariable,
          );

          if (check) {
            result.add(block);
          }
        } else {
          result.add(block);
        }
      }
    }
    return result;
  }

  List<Widget> buildAction(Map<String, dynamic>? configs, Color? color) {
    // Enable/ Disable Blog search
    bool enableBlogSearch = get(configs, ['enableBlogSearch'], false);

    // Enable / Disable Blog search
    bool enableProductSearch = get(configs, ['enableProductSearch'], false);

    // Enable / Disable Blog wishlist
    bool enableBlogWishlist = get(configs, ['enableBlogWishlist'], false);

    // Enable / Disable Product wishlist
    bool enableProductWishlist = get(configs, ['enableProductWishlist'], false);

    // Enable / Disable Notification
    bool enableNotification = get(configs, ['enableNotification'], true);

    // Enable / Disable cart
    bool enableCart = get(configs, ['enableCart'], false);

    // Enable / Disable cart count
    bool? enableCartCount = get(configs, ['enableNumberCart'], true);

    // Cart Icon
    Map iconCart = get(configs, ['iconCart'], {'type': 'feather', 'name': 'shopping-cart'});

    // Cart Image
    String? imageCart = get(configs, ['imageCart', 'src'], '');

    double pad = enableNotification && !enableCart ? 0 : 12;

    return [
      if (enableBlogSearch)
        SizedBox(
          width: 45,
          child: SearchFeature(
            enableSearchPost: true,
            child: Icon(FeatherIcons.search, size: 20, color: color),
          ),
        ),
      if (enableBlogWishlist)
        _ButtonNavigate(
          icon: FeatherIcons.heart,
          color: color,
          action: const {
            'type': 'tab',
            'route': '/',
            'args': {'key': 'screens_postWishlist'}
          },
        ),
      if (enableProductSearch)
        SizedBox(
          width: 45,
          child: SearchFeature(
            child: Icon(FeatherIcons.search, size: 20, color: color),
          ),
        ),
      if (enableProductWishlist)
        _ButtonNavigate(
          icon: FeatherIcons.heart,
          color: color,
          action: const {
            'type': 'tab',
            'route': '/',
            'args': {'key': 'screens_wishlist'}
          },
        ),
      if (enableNotification) IconNotification(color: color),
      if (enableCart)
        CirillaCartIcon(
          icon: CirillaIconBuilder(data: iconCart, size: 20, color: color),
          enableCount: enableCartCount,
          cartImage: imageCart!.isNotEmpty
              ? CirillaCacheImage(
            imageCart,
            width: 32,
            height: 64,
          )
              : null,
          color: Colors.transparent,
        ),
      SizedBox(width: pad),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Observer(
        builder: (_) {
          String languageKey = _settingStore.languageKey;

          Data? profileData = _settingStore.data?.screens?['profile'];

          WidgetConfig? widgetConfig = profileData?.widgets?['profilePage'];

          String layout = widgetConfig?.layout ?? Strings.profileLayoutStyle1;

          Map<String, dynamic>? fields = widgetConfig?.fields ?? {};

          String? textCopyRight = get(fields, ['textCopyRight', languageKey], '© Cirrilla 2020');
          List? socials = get(fields, ['itemSocial'], []);
          List blocksFields = get(fields, ['blocks'], initProfileBlocks);

          // Padding
          Map<String, dynamic>? paddingData = get(widgetConfig?.styles, ['padding']);
          EdgeInsetsDirectional padding =
          paddingData != null ? ConvertData.space(paddingData, 'padding') : defaultScreenPadding;

          List blocks = getBlocks(blocksFields);

          switch (layout) {
            case Strings.profileLayoutStyle2:
              return LayoutStyle2(
                isLogin: _authStore.isLogin,
                user: _authStore.user,
                blocks: blocks,
                getItems: getItemBlocks,
                footer: Footer(
                  copyright: textCopyRight,
                  socials: socials,
                ),
                padding: padding,
                actions: (color) => buildAction(profileData?.configs, color),
              );
            case Strings.profileLayoutStyle3:
              return LayoutStyle3(
                isLogin: _authStore.isLogin,
                user: _authStore.user,
                blocks: blocks,
                getItems: getItemBlocks,
                footer: Footer(
                  copyright: textCopyRight,
                  socials: socials,
                ),
                padding: padding,
                actions: (color) => buildAction(profileData?.configs, color),
              );
            case Strings.profileLayoutStyle4:
              return LayoutStyle4(
                isLogin: _authStore.isLogin,
                user: _authStore.user,
                blocks: blocks,
                getItems: getItemBlocks,
                footer: Footer(
                  copyright: textCopyRight,
                  socials: socials,
                ),
                padding: padding,
                actions: (color) => buildAction(profileData?.configs, color),
              );
            default:
              return LayoutStyle1(
                isLogin: _authStore.isLogin,
                user: _authStore.user,
                blocks: blocks,
                getItems: getItemBlocks,
                footer: Footer(
                  copyright: textCopyRight,
                  socials: socials,
                ),
                padding: padding,
                actions: (color) => buildAction(profileData?.configs, color),
              );
          }
        },
      ),
    );
  }
}


class _ButtonNavigate extends StatelessWidget with NavigationMixin {
  final IconData icon;
  final Color? color;
  final Map<String, dynamic>? action;

  const _ButtonNavigate({Key? key, required this.icon, this.action, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20, color: color),
      splashRadius: 28,
      onPressed: () => navigate(context, action),
    );
  }
}
