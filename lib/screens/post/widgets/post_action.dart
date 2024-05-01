import 'package:cirilla/models/models.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/top.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostAction extends StatelessWidget {
  final Post? post;
  final Color? color;
  final Axis axis;
  final Map<String, dynamic>? configs;
  final GlobalKey? dataKey;

  const PostAction({
    Key? key,
    this.post,
    this.color,
    this.axis = Axis.horizontal,
    this.configs,
    this.dataKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool enableComment = get(configs, ['enableAppbarComment'], true);
    bool enableWishlist = get(configs, ['enableAppbarWishList'], true);
    bool enableShare = get(configs, ['enableAppbarShare'], true);

    if (axis == Axis.vertical) {
      return Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              if (enableComment) ...[
                PostNavigateComment(
                  post: post,
                  color: color,
                  dataKey: dataKey,
                ),
                const SizedBox(height: 32),
              ],
              if (enableWishlist) ...[
                PostWishlist(post: post, color: color),
                const SizedBox(height: 32),
              ],
              if (enableShare) PostShare(post: post, color: color),
            ],
          ));
    }
    return Container(
      alignment: Alignment.centerLeft,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 32,
        children: [
          if (enableComment)
            PostNavigateComment(
              post: post,
              color: color,
              dataKey: dataKey,
            ),
          if (enableWishlist) PostWishlist(post: post, color: color),
          if (enableShare) PostShare(post: post, color: color),
        ],
      ),
    );
  }
}

class PostWishlist extends StatefulWidget {
  final Post? post;
  final Color? color;

  const PostWishlist({
    Key? key,
    this.post,
    this.color,
  }) : super(key: key);

  @override
  State<PostWishlist> createState() => _PostWishlistState();
}

class _PostWishlistState extends State<PostWishlist> with PostWishListMixin {
  ///
  /// Handle wishlist
  void _wishlist(BuildContext context) {
    if (widget.post == null || widget.post!.id == null) return;
    addWishList(postId: widget.post!.id);
  }

  @override
  Widget build(BuildContext context) {
    bool select = existWishList(postId: widget.post!.id);
    return InkWell(
      onTap: () => _wishlist(context),
      child: Icon(!select ? Icons.bookmark_border : Icons.bookmark, size: 20, color: widget.color),
    );
  }
}

class PostNavigateComment extends StatelessWidget {
  final Post? post;
  final Color? color;
  final GlobalKey? dataKey;
  const PostNavigateComment({
    Key? key,
    this.post,
    this.color,
    this.dataKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (dataKey?.currentContext != null) {
          Scrollable.ensureVisible(dataKey!.currentContext!,
              duration: const Duration(
                milliseconds: 600,
              ));
        }
      },
      child: Icon(FeatherIcons.messageCircle, size: 18, color: color),
    );
  }
}

class PostShare extends StatelessWidget {
  final Post? post;
  final Color? color;
  const PostShare({
    Key? key,
    this.post,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingStore settingStore = Provider.of<SettingStore>(context);

    Data? data = settingStore.data!.screens!['postDetail'];

    // Configs
    WidgetConfig? widgetConfig = data != null ? data.widgets!['postDetailPage'] : null;

    // fields
    Map<String, dynamic>? fields = widgetConfig?.fields;

    bool enableDynamicLink = get(fields, ['enableDynamicLink'], false);

    DynamicLink? dynamicLink;

    if (enableDynamicLink == true) {
      String dynamicLinkType = get(fields, ['dynamicLinkType'], 'long_link');
      String dynamicLinkUriPrefix = get(fields, ['dynamicLinkUriPrefix', settingStore.languageKey], '').trim();

      String fallBackUrl = get(fields, ['dynamicLinkFallbackUrl', settingStore.languageKey], '').trim();

      Uri? dynamicLinkFallbackUrl = Uri.tryParse(fallBackUrl);

      // Data android
      String androidPackageName = get(fields, ['dynamicLinkAndroidPackageName', settingStore.languageKey], '').trim();
      int? androidMinimumVersion =
          ConvertData.stringToInt(get(fields, ['dynamicLinkAndroidMinimumVersion', settingStore.languageKey], null));

      // Data iOS
      String iosBundleId = get(fields, ['dynamicLinkIosBundleId', settingStore.languageKey], '').trim();
      String? iosAppStoreId = get(fields, ['dynamicLinkIosAppStoreId', settingStore.languageKey], '').trim();
      String? iosMinimumVersion = get(fields, ['dynamicLinkIosMinimumVersion', settingStore.languageKey], '0').trim();

      // Model Dynamic Link parameters
      dynamicLink = DynamicLink(
        dynamicLinkUriPrefix: dynamicLinkUriPrefix,
        permalink: post!.link!,
        dynamicLinkType: dynamicLinkType,
        androidParameters: AndroidParameters(
          packageName: androidPackageName,
          minimumVersion: androidMinimumVersion,
          fallbackUrl: dynamicLinkFallbackUrl,
        ),
        iosParameters: IOSParameters(
          bundleId: iosBundleId,
          appStoreId: iosAppStoreId,
          minimumVersion: iosMinimumVersion,
          fallbackUrl: dynamicLinkFallbackUrl,
          ipadBundleId: iosBundleId,
          ipadFallbackUrl: dynamicLinkFallbackUrl,
        ),
      );
    }

    return InkWell(
      onTap: () => shareLink(
        permalink: post!.link!,
        name: post!.postTitle,
        dynamicLink: dynamicLink,
        context: context,
      ),
      child: Icon(FeatherIcons.share2, size: 18, color: color),
    );
  }
}
