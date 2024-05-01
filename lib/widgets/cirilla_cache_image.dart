import 'package:cached_network_image/cached_network_image.dart';
import 'package:cirilla/constants/assets.dart';
import 'package:cirilla/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ui/ui.dart';

class CirillaCacheImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;

  final BoxFit fit;

  final Color color;
  final Color? colorFilter;
  const CirillaCacheImage(
    this.url, {
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color = Colors.transparent,
    this.colorFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isWeb) {
      return ImageLoading(url, width: width, height: height, fit: fit, color: color);
    }
    if (url?.endsWith('.svg') == true) {
      return SvgPicture.network(
        url!,
        placeholderBuilder: (_) => _LoadingCacheImage(
          width: width,
          height: height,
          color: color,
        ),
        width: width,
        height: height,
        color: colorFilter,
        cacheColorFilter: colorFilter != null,
        colorBlendMode: colorFilter != null ? BlendMode.color : BlendMode.srcIn,
      );
    }
    return CachedNetworkImage(
      imageUrl: url != null && url!.isNotEmpty ? url! : Assets.noImageUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        color: color,
        width: width,
        height: height,
        child: const Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Image.network(
        Assets.noImageUrl,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}

class _LoadingCacheImage extends StatelessWidget {
  final double? width;
  final double? height;
  final Color color;

  const _LoadingCacheImage({
    this.width,
    this.height,
    this.color = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      width: width,
      height: height,
      child: const Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
