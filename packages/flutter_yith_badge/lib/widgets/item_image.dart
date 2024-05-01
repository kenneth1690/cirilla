import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_svg/flutter_svg.dart';

const emptyUrl = "https://cdn.rnlab.io/placeholder-416x416.png";

double _sizeLoading = 50;

class ItemImage extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  final Color? colorFilter;
  final double? width;

  const ItemImage(
    this.url, {
    Key? key,
    this.fit = BoxFit.contain,
    this.colorFilter,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _ImageLoading(url, fit: fit, width: width);
    }
    if (url?.endsWith('.svg') == true) {
      return SvgPicture.network(
        url!,
        placeholderBuilder: (_) => _LoadingCacheImage(),
        color: colorFilter,
        cacheColorFilter: colorFilter != null,
        colorBlendMode: colorFilter != null ? BlendMode.color : BlendMode.srcIn,
        width: width,
      );
    }

    return Image.network(
      url != null && url!.isNotEmpty ? url! : emptyUrl,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          // If the image is fully loaded, return the image
          return child;
        } else {
          return _LoadingCacheImage(width: width);
        }
      },
      errorBuilder: (_, __, ___) => Image.network(
        emptyUrl,
        width: width ?? _sizeLoading,
        fit: fit,
      ),
      fit: fit,
      width: width,
    );
  }
}

class _LoadingCacheImage extends StatelessWidget {
  final double? width;
  const _LoadingCacheImage({this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? _sizeLoading,
      height: width ?? _sizeLoading,
      child: const Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}

class _ImageLoading extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  final double? width;

  const _ImageLoading(
    this.url, {
    Key? key,
    this.fit = BoxFit.contain,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget errorWidget = Image.network(
      emptyUrl,
      width: width ?? _sizeLoading,
      fit: fit,
    );

    return FadeInImage.memoryNetwork(
      placeholder: Uint8List.fromList([]),
      placeholderErrorBuilder: (context, url, error) => _LoadingCacheImage(width: width),
      imageErrorBuilder: (context, url, error) => errorWidget,
      image: url ?? "",
      fit: fit,
      width: width,
    );
  }
}
