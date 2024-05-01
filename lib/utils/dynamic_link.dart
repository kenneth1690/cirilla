import 'package:cirilla/top.dart';

class DynamicLink {
  final String dynamicLinkUriPrefix;
  final String permalink;
  final IOSParameters? iosParameters;
  final AndroidParameters? androidParameters;
  final DynamicLinkParameters? _parameters;
  final String? dynamicLinkType;

  DynamicLink({
    required this.dynamicLinkUriPrefix,
    required this.permalink,
    this.iosParameters,
    this.androidParameters,
    this.dynamicLinkType,
  }) : _parameters = DynamicLinkParameters(
          link: Uri.parse(permalink),
          uriPrefix: dynamicLinkUriPrefix,
          androidParameters: androidParameters,
          iosParameters: iosParameters,
        );

  // Short Dynamic Link
  Future<Uri> dynamicShortLink() async {
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(_parameters!);
    return dynamicLink.shortUrl;
  }

  // Long Dynamic Link
  Future<Uri> dynamicLongLink() async {
    return await FirebaseDynamicLinks.instance.buildLink(_parameters!);
  }
}
