import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/types/types.dart';
import 'package:flutter/material.dart';
import 'package:ui/tab/sticky_tab_bar_delegate.dart';

class MemberTabWidget extends StatelessWidget {
  final List<String> tabs;
  final TranslateType translate;
  final TabController? controller;
  final Function(String value)? onChanged;

  const MemberTabWidget({
    Key? key,
    this.tabs = const [],
    required this.translate,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: StickyTabBarDelegate(
        child: Container(
          alignment: AlignmentDirectional.centerStart,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: TabBar(
            labelPadding: paddingHorizontalMedium,
            onTap: (int index) => onChanged?.call(tabs[index]),
            isScrollable: true,
            labelColor: theme.primaryColor,
            controller: controller,
            labelStyle: theme.textTheme.titleSmall,
            unselectedLabelColor: theme.textTheme.titleSmall?.color,
            indicatorWeight: 2,
            indicatorColor: theme.primaryColor,
            indicatorPadding: paddingHorizontalMedium,
            tabs: List.generate(tabs.length, (index) => Text(translate("buddypress_${tabs[index]}").toUpperCase())),
          ),
        ),
        height: 80,
      ),
    );
  }
}
