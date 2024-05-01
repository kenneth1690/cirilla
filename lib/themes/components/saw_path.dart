import 'package:flutter/material.dart';
import 'paths/paths.dart';

class SawPathComponent extends StatelessWidget {
  /// The background color of SawPathComponent
  final Color background;

  ///a widget for showing shadows.
  final BoxShadow boxShadow;

  /// Called when the user taps this list tile.
  final GestureTapCallback? onTap;

  /// The widget of layout
  final Widget child;

  /// The example
  /// ```dart
  /// SawPathComponent(
  ///   background: Colors.blue,
  ///   boxShadow: BoxShadow(),
  ///   child: Container(
  ///   height: 150,
  ///   width: 300,
  ///   child: Text('a')),
  ///   )
  /// ```

  const SawPathComponent({
    Key? key,
    required this.child,
    required this.background,
    required this.boxShadow,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 8,
            right: 8,
            top: 0,
            bottom: -4,
            child: Container(
              decoration: BoxDecoration(
                color: background,
                borderRadius: const BorderRadiusDirectional.only(bottomEnd: Radius.circular(8)),
                boxShadow: [boxShadow],
              ),
            ),
          ),
          CustomPaint(
            painter: _ClipShadowPainter(
              clipper: SawPath(),
              shadow: boxShadow,
            ),
            child: ClipPath(
              clipper: SawPath(),
              child: Container(
                color: background,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClipShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
