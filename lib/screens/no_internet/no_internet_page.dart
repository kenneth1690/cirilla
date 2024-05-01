import 'package:cirilla/constants/color_block.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  static const routeName = '/no_internet';

  const NoInternetPage({
    Key? key,
    this.suggestReopen = false,
  }) : super(key: key);

  final bool suggestReopen;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 90,
            width: 90,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.1), spreadRadius: 5),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/images/global_refresh.png',
                width: 50,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Text(
            translate('no_internet'),
            style: theme.textTheme.bodyLarge?.copyWith(color: ColorBlock.redDark, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              suggestReopen
                  ? translate('no_internet_content_1')
                  : translate('no_internet_content_2'),
              style: theme.textTheme.bodyMedium?.copyWith(color: ColorBlock.gray10),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
