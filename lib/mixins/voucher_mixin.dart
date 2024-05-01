import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:flutter/material.dart';

mixin VoucherMixin {
  /// Create image widget of Voucher.
  ///
  ///
  /// If loading is true Shimmer will be showed
  Widget buildImage({
    Widget Function(double, double)? image,
    double size = 64,
    double radius = 2,
    bool isLoading = true,
  }) {
    if (isLoading) {
      return CirillaShimmer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(radius)),
        ),
      );
    }
    return image?.call(size, radius) ?? Container();
  }

  /// Create name widget of Voucher.
  ///
  ///
  /// If loading is true Shimmer will be showed
  Widget buildName({
    Widget? name,
    double shimmerWidth = 140,
    double shimmerHeight = 16,
    bool isLoading = true,
  }) {
    if (isLoading) {
      return CirillaShimmer(
        child: Container(
          width: shimmerWidth,
          height: shimmerHeight,
          decoration: const BoxDecoration(color: Colors.white),
        ),
      );
    }
    return name ?? Container();
  }

  /// Create offer widget of Voucher.
  ///
  ///
  /// If loading is true Shimmer will be showed
  Widget buildOffer({
    Widget? offer,
    double shimmerWidth = 80,
    double shimmerHeight = 14,
    bool isLoading = true,
  }) {
    if (isLoading) {
      return CirillaShimmer(
        child: Container(
          width: shimmerWidth,
          height: shimmerHeight,
          decoration: const BoxDecoration(color: Colors.white),
        ),
      );
    }
    return offer ?? Container();
  }

  /// Create time expired widget of Voucher.
  ///
  ///
  /// If loading is true Shimmer will be showed
  Widget buildExpired({
    String? expired,
    required ThemeData theme,
    double shimmerWidth = 60,
    double shimmerHeight = 12,
    bool isLoading = true,
  }) {
    if (isLoading) {
      return CirillaShimmer(
        child: Container(
          width: shimmerWidth,
          height: shimmerHeight,
          decoration: const BoxDecoration(color: Colors.white),
        ),
      );
    }
    return Text(
      expired ?? '',
      style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.labelSmall?.color),
    );
  }

  /// Create status widget of Voucher.
  ///
  ///
  /// If loading is true Shimmer will be showed
  Widget buildStatus({
    Widget? status,
    double shimmerWidth = 50,
    double shimmerHeight = 12,
    bool isLoading = true,
  }) {
    if (isLoading) {
      return CirillaShimmer(
        child: Container(
          width: shimmerWidth,
          height: shimmerHeight,
          decoration: const BoxDecoration(color: Colors.white),
        ),
      );
    }
    return status ?? Container();
  }

  /// Create icon checkbox widget of Voucher.
  ///
  ///
  /// If loading is true Shimmer will be showed
  Widget buildIconCheckbox({
    Widget? icon,
    double shimmerSize = 20,
    bool isLoading = true,
  }) {
    if (isLoading) {
      return CirillaShimmer(
        child: Container(
          width: shimmerSize,
          height: shimmerSize,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(shimmerSize / 2)),
        ),
      );
    }
    return icon ?? Container();
  }
}
