import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {
  final Widget child;

  const ContainerWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: 4, bottom: 16), child: child);
  }
}

class ContainerBorderWidget extends StatelessWidget {
  final Widget child;

  const ContainerBorderWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(border: Border.all(color: theme.dividerColor), borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: child,
    );
  }
}
