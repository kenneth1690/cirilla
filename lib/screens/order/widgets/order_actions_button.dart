import 'package:cirilla/mixins/mixins.dart';

import 'package:cirilla/types/types.dart';

import 'package:cirilla/utils/app_localization.dart';

import 'package:flutter/material.dart';

/// Create Action Button
class ActionButton extends StatelessWidget with AppBarMixin, TransitionMixin {
  /// Title of button

  final String titleText;

  /// Widget content

  final Widget? widgetContent;

  /// Function onPressed

  final Function(BuildContext context)? onPressed;

  /// Constructor

  const ActionButton({super.key, required this.titleText, this.widgetContent, this.onPressed});

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return ElevatedButton(
      onPressed: () =>
          onPressed?.call(context) ??
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, _, __) => Scaffold(
                appBar: baseStyleAppBar(context, title: translate(titleText)),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: widgetContent,
                ),
              ),
              transitionsBuilder: slideTransition,
            ),
          ),
      child: Text(translate(titleText)),
    );
  }
}