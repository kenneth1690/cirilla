import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

const int _kIndeterminateLinearDuration = 1800;
/// A base class for Material Design progress indicators.
///
/// This widget cannot be instantiated directly. For a linear progress
/// indicator, see [LinearProgressIndicator]. For a circular progress indicator,
/// see [CircularProgressIndicator].
///
abstract class _ProgressIndicatorGradientUi extends StatefulWidget {
  /// Creates a progress indicator.
  ///
  /// The [value] argument can either be null for an indeterminate
  /// progress indicator, or a non-null value between 0.0 and 1.0 for a
  /// determinate progress indicator.
  ///
  /// ## Accessibility
  ///
  /// The [semanticsLabel] can be used to identify the purpose of this progress
  /// bar for screen reading software. The [semanticsValue] property may be used
  /// for determinate progress indicators to indicate how much progress has been made.
  const _ProgressIndicatorGradientUi({
    Key? key,
    this.value,
    required this.backgroundColor,
    this.semanticsLabel,
    this.semanticsValue,
  }) : super(key: key);

  /// If non-null, the value of this progress indicator.
  ///
  /// A value of 0.0 means no progress and 1.0 means that progress is complete.
  /// The value will be clamped to be in the range 0.0-1.0.
  ///
  /// If null, this progress indicator is indeterminate, which means the
  /// indicator displays a predetermined animation that does not indicate how
  /// much actual progress is being made.
  final double? value;

  /// The progress indicator's background color.
  ///
  /// It is up to the subclass to implement this in whatever way makes sense
  /// for the given use case. See the subclass documentation for details.
  final Color backgroundColor;

  /// {@template flutter.progress_indicator.ProgressIndicator.color}
  /// The progress indicator's color.
  ///
  /// This is only used if [ProgressIndicator.valueColor] is null.
  /// If [ProgressIndicator.color] is also null, then the ambient
  /// [ProgressIndicatorThemeData.color] will be used. If that
  /// is null then the current theme's [ColorScheme.primary] will
  /// be used by default.
  /// {@endtemplate}
  final String? semanticsLabel;

  /// {@template flutter.progress_indicator.ProgressIndicator.semanticsValue}
  /// The [SemanticsProperties.value] for this progress indicator.
  ///
  /// This will be used in conjunction with the [semanticsLabel] by
  /// screen reading software to identify the widget, and is primarily
  /// intended for use with determinate progress indicators to announce
  /// how far along they are.
  ///
  /// For determinate progress indicators, this will be defaulted to
  /// [ProgressIndicator.value] expressed as a percentage, i.e. `0.1` will
  /// become '10%'.
  /// {@endtemplate}
  final String? semanticsValue;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(PercentProperty('value', value, showName: false, ifNull: '<indeterminate>'));
  }

  Widget _buildSemanticsWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    String? expandedSemanticsValue = semanticsValue;
    if (value != null) {
      expandedSemanticsValue ??= '${(value! * 100).round()}%';
    }
    return Semantics(
      label: semanticsLabel,
      value: expandedSemanticsValue,
      child: child,
    );
  }
}

class LinearProgressIndicatorGradientComponent extends _ProgressIndicatorGradientUi {
  /// The indicator line is displayed with [valueColor], an animated value.
  final List<Color> valueColors;
  const LinearProgressIndicatorGradientComponent({
    Key? key,
    double? value,
    required Color backgroundColor,
    required this.valueColors,
    this.minHeight,
    String? semanticsLabel,
    String? semanticsValue,
  })  : assert(minHeight == null || minHeight > 0),
        super(
        key: key,
        value: value,
        backgroundColor: backgroundColor,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
      );

  final double? minHeight;

  @override
  State<LinearProgressIndicatorGradientComponent> createState() => _LinearProgressIndicatorState();
}

/// The example
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:food/components/indicator_line.dart';
/// void main() => runApp(const MyApp());
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///  static const String _title = 'Flutter Code Sample';
///   @override
///  Widget build(BuildContext context) {
///    return const MaterialApp(
///       title: _title,
///      home: MyStatefulWidget(),
///     );
///  }
/// }
/// class MyStatefulWidget extends StatefulWidget {
///   const MyStatefulWidget({super.key});
///   @override
///   State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
/// }
/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
/// class _MyStatefulWidgetState extends State<MyStatefulWidget>
///     with TickerProviderStateMixin {
///   late AnimationController controller;
///   @override
///   void initState() {
///     controller = AnimationController(
///       vsync: this,
///       duration: const Duration(seconds: 5),
///     )..addListener(() {
///         setState(() {});
///       });
///    controller.repeat(reverse: true);
///     super.initState();
///   }
///   @override
///   void dispose() {
///     controller.dispose();
///     super.dispose();
///  }
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Padding(
///         padding: const EdgeInsets.all(20.0),
///         child: Column(
///          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
///          children: <Widget>[
///            const Text(
///              'Linear progress indicator with a fixed color',
///              style: TextStyle(fontSize: 20),
///            ),
///           LinearProgressIndicatorGradientComponent(
///              value: controller.value,
///              backgroundColor: Colors.grey,
///              valueColors: [
///               Colors.blue,
///                Colors.orangeAccent.withOpacity(0.75),
///               ],
///            ),
///        ],
///       ),
///     ),
///   );
///  }
///}
///```


class _LinearProgressIndicatorState extends State<LinearProgressIndicatorGradientComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateLinearDuration),
      vsync: this,
    );
    if (widget.value == null) _controller.repeat();
  }

  @override
  void didUpdateWidget(LinearProgressIndicatorGradientComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIndicator(BuildContext context, double animationValue, TextDirection textDirection) {
    return widget._buildSemanticsWrapper(
      context: context,
      child: Container(
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: widget.minHeight ?? 4.0,
        ),
        child: CustomPaint(
          painter: _LinearProgressIndicatorPainter(
            backgroundColor: widget.backgroundColor,
            valueColors: widget.valueColors,
            value: widget.value, // may be null
            animationValue: animationValue, // ignored if widget.value is not null
            textDirection: textDirection,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    if (widget.value != null) return _buildIndicator(context, _controller.value, textDirection);

    return AnimatedBuilder(
      animation: _controller.view,
      builder: (BuildContext context, Widget? child) {
        return _buildIndicator(context, _controller.value, textDirection);
      },
    );
  }
}

class _LinearProgressIndicatorPainter extends CustomPainter {
  const _LinearProgressIndicatorPainter({
    required this.backgroundColor,
    required this.valueColors,
    this.value,
    required this.animationValue,
    required this.textDirection,
  });

  final Color backgroundColor;
  final List<Color> valueColors;
  final double? value;
  final double animationValue;
  final TextDirection textDirection;

  // The indeterminate progress animation displays two lines whose leading (head)
  // and trailing (tail) endpoints are defined by the following four curves.
  static const Curve line1Head = Interval(
    0.0,
    750.0 / _kIndeterminateLinearDuration,
    curve: Cubic(0.2, 0.0, 0.8, 1.0),
  );
  static const Curve line1Tail = Interval(
    333.0 / _kIndeterminateLinearDuration,
    (333.0 + 750.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.4, 0.0, 1.0, 1.0),
  );
  static const Curve line2Head = Interval(
    1000.0 / _kIndeterminateLinearDuration,
    (1000.0 + 567.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.0, 0.0, 0.65, 1.0),
  );
  static const Curve line2Tail = Interval(
    1267.0 / _kIndeterminateLinearDuration,
    (1267.0 + 533.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.10, 0.0, 0.45, 1.0),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint);

    void drawBar(double x, double width) {
      if (width <= 0.0) return;

      final double left;
      switch (textDirection) {
        case TextDirection.rtl:
          left = size.width - width - x;
          break;
        case TextDirection.ltr:
          left = x;
          break;
      }
      paint.shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(width, size.height),
        valueColors,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(
              left,
              0,
              width,
              size.height,
            ),
            Radius.circular(size.height / 2)),
        paint,
      );
    }

    if (value != null) {
      drawBar(0.0, value!.clamp(0.0, 1.0) * size.width);
    } else {
      final double x1 = size.width * line1Tail.transform(animationValue);
      final double width1 = size.width * line1Head.transform(animationValue) - x1;

      final double x2 = size.width * line2Tail.transform(animationValue);
      final double width2 = size.width * line2Head.transform(animationValue) - x2;

      drawBar(x1, width1);
      drawBar(x2, width2);
    }
  }

  @override
  bool shouldRepaint(_LinearProgressIndicatorPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColors != valueColors ||
        oldPainter.value != value ||
        oldPainter.animationValue != animationValue ||
        oldPainter.textDirection != textDirection;
  }
}
