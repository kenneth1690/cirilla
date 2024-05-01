import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonSignin extends StatelessWidget with GeneralMixin {
  final ShowMessageType? showMessage;
  final double? pad;

  const ButtonSignin({super.key, this.showMessage, this.pad});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    SettingStore settingStore = Provider.of<SettingStore>(context);

    bool enableRegister = getConfig(settingStore, ['enableRegister'], true);

    return Column(
      children: [
        Text(
          translate('login_sign_in_to_receive'),
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: pad ?? itemPaddingExtraLarge),
        Row(
          children: [
            if (enableRegister) ...[
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    key: const Key('login_btn_create_account'),
                    onPressed: () => Navigator.of(context).pushNamed(RegisterScreen.routeName),
                    style: ElevatedButton.styleFrom(
                      textStyle: theme.textTheme.titleSmall,
                    ),
                    child: Text(
                      translate('login_btn_create_account'),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: itemPaddingMedium),
            ],
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  key: const Key('login_btn_login'),
                  onPressed: () =>
                      Navigator.of(context).pushNamed(LoginScreen.routeName, arguments: {'showMessage': showMessage}),
                  style: ElevatedButton.styleFrom(
                    textStyle: theme.textTheme.titleSmall,
                  ),
                  child: Text(
                    translate('login_btn_login'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
