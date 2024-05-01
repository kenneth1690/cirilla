import 'package:cirilla/models/models.dart';
import 'package:cirilla/widgets/cirilla_shimmer.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CustomerItem extends StatelessWidget {
  final Customer? customer;
  final GestureTapCallback? onClick;

  const CustomerItem({
    super.key,
    this.customer,
    this.onClick,
  });

  Widget buildAvatar({bool loading = true, double shimmerSize = 30}) {
    if (loading) {
      return CirillaShimmer(
        child: Container(
          height: shimmerSize,
          width: shimmerSize,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(shimmerSize / 2),
      child: CirillaCacheImage(customer?.avatar, width: shimmerSize, height: shimmerSize),
    );
  }

  Widget buildName({
    bool loading = true,
    double shimmerWidth = 150,
    double shimmerHeight = 14,
    required ThemeData theme,
  }) {
    if (loading) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          color: Colors.white,
        ),
      );
    }
    return Text(customer?.getName() ?? "", style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.titleMedium?.color));
  }

  Widget buildEmail({
    bool loading = true,
    double shimmerWidth = 90,
    double shimmerHeight = 12,
    required ThemeData theme,
  }) {
    if (loading) {
      return CirillaShimmer(
        child: Container(
          height: shimmerHeight,
          width: shimmerWidth,
          color: Colors.white,
        ),
      );
    }
    return Text(
      customer?.email ?? "",
      style: theme.textTheme.labelSmall,
    );
  }

  void onClickCustomer() {
    if (customer?.id != null) {
      onClick?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool loading = customer?.id == null;

    return CirillaTile(
      leading: buildAvatar(loading: loading),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildName(loading: loading, theme: theme),
          buildEmail(loading: loading, theme: theme),
        ],
      ),
      height: 48,
      onTap: onClickCustomer,
      isDivider: false,
      isChevron: false,
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
