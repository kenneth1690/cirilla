import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:flutter/material.dart';
import 'package:awesome_drawer_bar/awesome_drawer_bar.dart' as drawer;
import 'package:provider/provider.dart';
import 'sticky_wrapper.dart';
export 'package:awesome_drawer_bar/awesome_drawer_bar.dart' show StyleState, AwesomeDrawerBarController;

class AwesomeDrawerBar extends StatefulWidget {
  const AwesomeDrawerBar({
    super.key,
    this.type = drawer.StyleState.overlay,
    this.controller,
    required this.menuScreen,
    required this.mainScreen,
    this.slideWidth,
    this.slideHeight,
    this.borderRadius = 16.0,
    this.angle = 0.0,
    this.backgroundColor = Colors.white,
    this.shadowColor = Colors.white,
    this.showShadow = false,
    this.openCurve,
    this.closeCurve,
    this.duration,
    this.isRTL = false,
    this.disableOnCickOnMainScreen = false,
  }) : assert(angle <= 0.0 && angle >= -30.0);

  // Layout style
  final drawer.StyleState type;

  /// controller to have access to the open/close/toggle function of the drawer
  final drawer.AwesomeDrawerBarController? controller;

  /// Screen containing the menu/bottom screen
  final Widget menuScreen;

  /// Screen containing the main content to display
  final Widget mainScreen;

  /// Sliding width of the drawer - defaults to 275.0
  final double? slideWidth;
  final double? slideHeight;

  /// Border radius of the slided content - defaults to 16.0
  final double borderRadius;

  /// Rotation angle of the drawer - defaults to -12.0
  final double angle;

  /// Background color of the drawer shadows - defaults to white
  final Color backgroundColor;

  final Color shadowColor;

  /// Boolean, whether to show the drawer shadows - defaults to false
  final bool showShadow;

  /// Drawer slide out curve
  final Curve? openCurve;

  /// Drawer slide in curve
  final Curve? closeCurve;

  /// Drawer Duration
  final Duration? duration;

  /// Static function to determine the device text direction RTL/LTR
  final bool isRTL;

  final bool disableOnCickOnMainScreen;

  @override
  State<AwesomeDrawerBar> createState() => _AwesomeDrawerBarState();
}

class _AwesomeDrawerBarState extends State<AwesomeDrawerBar> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {

    // Get setting store data directly from the provider in order to avoid the need to pass it down from the parent widget
    SettingStore settingStore = Provider.of<SettingStore>(context, listen: false);
    // Get home screen data from the setting store
    Data homeData = settingStore.data!.screens!['home']!;
    // Get sidebar data from the home screen data
    bool enableSidebar = get(homeData.configs, ['enableSidebar'], true);

    if (!enableSidebar) {
      return StickyWrapper(child: widget.mainScreen);
    }

    return StickyWrapper(
      child: drawer.AwesomeDrawerBar(
      isRTL: widget.isRTL,
      type: widget.type,
      controller: widget.controller,
      slideHeight: widget.slideHeight,
      borderRadius: widget.borderRadius,
      backgroundColor: widget.backgroundColor,
      menuScreen: widget.menuScreen,
      showShadow: widget.showShadow,
      shadowColor: widget.shadowColor,
      mainScreen: widget.mainScreen,
      angle: widget.angle,
      // openCurve: Curves.fastOutSlowIn,
      // closeCurve: Curves.bounceIn,
      ),
    );
  }
}