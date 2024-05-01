import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/auth/reset_password_store.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:cirilla/utils/utils.dart';
import 'widgets/verify_code.dart';

class ResetScreen extends StatefulWidget {
  static const routeName = '/reset_password';
  const ResetScreen({Key? key}) : super(key: key);

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> with AppBarMixin, SnackMixin {
  late AuthStore _authStore;
  late ResetPasswordStore _resetPasswordStore;
  final _formKey = GlobalKey<FormState>();
  final _txtEmail = TextEditingController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authStore = Provider.of<AuthStore>(context);
    _resetPasswordStore = _authStore.resetPasswordStore;
  }

  void onSendOtp(BuildContext context, {String? email}) async {
    try {
      await _resetPasswordStore.resetPassword(email);
      if (context.mounted) onOpenInputOtp(context, email!);
    } on DioException catch (e) {
      _txtEmail.clear();
      if (context.mounted) {
        FocusScope.of(context).unfocus();
        showError(context, e);
      }
    }
  }

  void onOpenInputOtp(BuildContext context, String userLogin) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        String checkOTP = '';
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return VerifyCode(
              showError: checkOTP == 'Error',
              onReSend: () {
                onSendOtp(context, email: _txtEmail.text);
              },
              onVerify: (smsCode) async {
                try {
                  int otp = ConvertData.stringToInt(smsCode);
                  Map<String, dynamic> data = await _resetPasswordStore.verifyOtpResetPassword(
                    userLogin: userLogin,
                    otp: otp,
                  );
                  String token = get(data, ['token'], '');
                  if (token != '' && context.mounted) {
                    Navigator.of(context).pop();
                    FocusScope.of(context).unfocus();
                    _txtEmail.clear();
                    Navigator.of(context).pushNamed(ResetPasswordFormScreen.routeName, arguments: data);
                  } else {
                    setState(() => checkOTP = 'Error');
                  }
                } catch (e) {
                  setState(() => checkOTP = 'Error');
                }
              },
            );
          },
        );
      },
    );
  }

  void onSubmit(BuildContext context, {String? email, required TranslateType translate}) async {
    try {
      onSendOtp(context, email: email);
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Observer(
        builder: (_) {
          bool loading = _resetPasswordStore.loading;
          return Scaffold(
            appBar: baseStyleAppBar(context, title: translate('forgot_password_reset_password')),
            body: SafeArea(
              child: renderForm(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: paddingHorizontal.add(paddingVerticalMedium),
                        child: Column(
                          children: [
                            Text(translate('forgot_password_desc_app'), style: textTheme.bodyLarge),
                            const SizedBox(height: 10),
                            Text(translate('forgot_password_note'), style: textTheme.bodyLarge),
                            const SizedBox(height: 24),
                            renderEmailField(translate),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 48,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (!loading && _formKey.currentState!.validate()) {
                                    String email = _txtEmail.text;
                                    onSubmit(context, email: email, translate: translate);
                                  }
                                },
                                child: loading
                                    ? SpinKitThreeBounce(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        size: 20.0,
                                      )
                                    : Text(translate('forgot_password')),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget renderForm({required Widget child}) {
    return Form(
      key: _formKey,
      child: child,
    );
  }

  Widget renderEmailField(TranslateType translate) {
    return TextFormField(
      controller: _txtEmail,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('validate_user_email_required');
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: translate('input_username_required'),
      ),
    );
  }
}
