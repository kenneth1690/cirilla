import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/webview_flutter.dart';
import 'package:cirilla/widgets/cirilla_instagram.dart';
import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_all/flutter_html_all.dart';
import 'package:cirilla/utils/url_launcher.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/constants/styles.dart';
import 'package:provider/provider.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'cirilla_audio/cirilla_audio.dart';
import 'cirilla_webview.dart';

CustomRenderMatcher classMatcher(String className) => (context) {
  return context.tree.element?.className == className;
};

class CirillaHtml extends StatelessWidget {
  final String html;
  final Map<String, Style>? style;
  final bool shrinkWrap;
  final Map<CustomRenderMatcher, CustomRender>? customRenders;
  final List<String>? tagsList;

  const CirillaHtml({
    Key? key,
    required this.html,
    this.style,
    this.shrinkWrap = false,
    this.customRenders,
    this.tagsList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: html,
      style: {
        'p': Style(
          lineHeight: const LineHeight(1.8),
          fontSize: const FontSize(16),
        ),
        'div': Style(
          lineHeight: const LineHeight(1.8),
          fontSize: const FontSize(16),
        ),
        'img': Style(
          padding: paddingVerticalTiny,
        ),
        ...?style,
      },
      customRenders: {
        ...appCustomRenders,
        if (customRenders?.isNotEmpty == true) ...customRenders!,
      },
      tagsList: tagsList ?? Html.tags,
      onLinkTap: (
          String? url,
          RenderContext renderContext,
          Map<String, String> attributes,
          dom.Element? element,
          ) {
        if (url is String && Uri.parse(url).isAbsolute) {
          if (attributes['data-id-selector'] is String) {
            String queryString = Uri(queryParameters: {
              'app-builder-css': 'true',
              'id-selector': attributes['data-id-selector'],
            }).query;

            String urlData = url.contains("?") ? "$url&$queryString" : "$url?$queryString";
            Navigator.of(context).pushNamed(WebViewScreen.routeName, arguments: {
              'url': urlData,
              ...attributes,
              'name': element!.text,
            });
          } else {
            launch(url);
          }
        }
      },
      shrinkWrap: shrinkWrap,
    );
  }
}

class _TwitterView extends StatefulWidget {
  final StyledElement tree;

  const _TwitterView({
    required this.tree,
  });

  @override
  State<StatefulWidget> createState() => _TwitterViewState();
}

class _TwitterViewState extends State<_TwitterView> with LoadingMixin {
  late SettingStore _settingStore;
  late WebViewController _controller;

  bool _loading = true;

  @override
  void initState() {
    _settingStore = Provider.of<SettingStore>(context, listen: false);

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    List<String> attrs = [];
    for (String key in widget.tree.attributes.keys.toList()) {
      attrs.add('$key="${widget.tree.attributes[key]}"');
    }
    String theme = _settingStore.darkMode ? "dark" : "light";
    attrs.add('data-theme="$theme"');
    attrs.add('data-align="center"');
    String html = '<html><head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head><body><blockquote ${attrs.join(" ")}>${widget.tree.element?.innerHtml}</blockquote>\n<p><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script></p></body></html>';

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (progress == 100 && _loading) {
              setState(() {
                _loading = false;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url != "about:blank" && !request.url.contains("platform.twitter.com")) {
              return await openAppLink(request.url);
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..setBackgroundColor(Colors.transparent)
      ..loadHtmlString(html);

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }

    if (controller.platform is WebKitWebViewController) {
      (controller.platform as WebKitWebViewController).setAllowsBackForwardNavigationGestures(true);
    }

    _controller = controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 550),
            child: AspectRatio(
              aspectRatio: _loading ? 1 : 550 / 1015,
              child: WebViewWidget(
                controller: _controller,
              ),
            ),
          ),
          if (_loading)
            Positioned.fill(
              child: Center(
                child: buildLoadingOverlay(context),
              ),
            )
        ],
      ),
    );
  }
}

Map<CustomRenderMatcher, CustomRender> appCustomRenders = {
  tagMatcher("audio"): CustomRender.widget(widget: (context, buildChildren) {
    dom.Document document = html_parser.parse(context.tree.element?.innerHtml ?? '');
    dom.Element source = document.getElementsByTagName('source')[0];
    String uri = source.attributes['src'] ?? '';
    if (uri.isNotEmpty) {
      return CirillaAudio(uri: uri);
    }
    return Container();
  }),
  classMatcher("wavesurfer-block wavesurfer-audio"): CustomRender.widget(widget: (context, buildChildren) {
    dom.Document document = html_parser.parse(context.tree.element?.innerHtml ?? '');
    dom.Element source = document.getElementsByClassName('wavesurfer-player')[0];
    String uri = source.attributes['data-url'] ?? '';
    if (uri.isNotEmpty) {
      return CirillaAudio(uri: uri);
    }
    return Container();
  }),
  classMatcher("yith-par-message-variation hide"): CustomRender.widget(widget: (context, buildChildren) {
    return const SizedBox();
  }),
  classMatcher("instagram-media"): CustomRender.widget(widget: (context, buildChildren) {
    String? url = context.tree.element?.attributes['data-instgrm-permalink'];
    if (url != null) {
      Uri uri = Uri.parse(url);
      return CirillaInstagram(id: uri.pathSegments[1]);
    }
    return Container();
  }),
  classMatcher("twitter-tweet"): CustomRender.widget(widget: (context, buildChildren) {
    EdgeInsets? margin = context.style.margin;
    EdgeInsets? padding = context.style.padding;

    double marginLeft = margin?.left ?? 0;
    double marginRight = margin?.right ?? 0;
    double paddingLeft = padding?.left ?? 0;
    double paddingRight = padding?.right ?? 0;

    double spacing = (marginLeft + paddingLeft) - (marginRight + paddingRight);

    return Padding(
      padding: EdgeInsets.only(right: spacing < 0 ? -spacing : spacing, top: 12, bottom: 12),
      child: _TwitterView(tree: context.tree),
    );
  }),
  tagMatcher("table"): CustomRender.widget(
    widget: (context, buildChildren) => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: tableRender.call().widget!.call(context, buildChildren),
    ),
  ),
  audioMatcher(): audioRender(),
  iframeMatcher(): iframeRender(),
  svgTagMatcher(): svgTagRender(),
  svgDataUriMatcher(): svgDataImageRender(),
  svgAssetUriMatcher(): svgAssetImageRender(),
  svgNetworkSourceMatcher(): svgNetworkImageRender(),
  videoMatcher(): videoRender(),
};