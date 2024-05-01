import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/auth/auth_store.dart';
import 'package:cirilla/store/auth/reset_password_store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../login_screen.dart';

class ResetPasswordFormScreen extends StatefulWidget {
  static const String routeName = '/reset_password';

  final HandleLoginType? handleLogin;

  const ResetPasswordFormScreen({Key? key, this.handleLogin}) : super(key: key);
  @override
  State<ResetPasswordFormScreen> createState() => _ResetPasswordFormScreenState();
}

class _ResetPasswordFormScreenState extends State<ResetPasswordFormScreen> with SnackMixin, AppBarMixin {
  late AuthStore _authStore;
  late ResetPasswordStore _resetPasswordStore;

  final _formKey = GlobalKey<FormState>();
  final _txtNewPassword = TextEditingController();
  final _txtConfirmPassword = TextEditingController();

  bool obscureTextPassword = true;
  bool obscureTextNewPassword = true;
  bool obscureTextConfirmPassword = true;

  FocusNode? _newPasswordFocusNode;
  FocusNode? _confirmPasswordFocusNode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authStore = Provider.of<AuthStore>(context);
    _resetPasswordStore = _authStore.resetPasswordStore;
  }

  @override
  void initState() {
    super.initState();
    _newPasswordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _txtNewPassword.dispose();
    _txtConfirmPassword.dispose();

    _newPasswordFocusNode!.dispose();
    _confirmPasswordFocusNode!.dispose();
    super.dispose();
  }

  void submit() async {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String token = get(args, ['token'], '');
    try {
      await _resetPasswordStore.updatePassword(
        token: token,
        newPassWord: _txtConfirmPassword.text,
      );
      if (mounted) {
        Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst);
        Navigator.pushNamed(context, LoginScreen.routeName, arguments: {
          'showMessage': ({String? message}) {
            avoidPrint('112');
          }
        });
      }
    } on DioException catch (e) {
      if (mounted) showError(context, e);
    }
  }

  void updateObscure(String type) {
    setState(() {
      switch (type) {
        case 'confirm_password':
          obscureTextConfirmPassword = !obscureTextConfirmPassword;
          return;
        case 'new_password':
          obscureTextNewPassword = !obscureTextNewPassword;
          return;
        default:
          obscureTextPassword = !obscureTextPassword;
          return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Observer(
        builder: (_) {
          bool loading = _resetPasswordStore.loadingUpdate;
          return Scaffold(
            appBar: baseStyleAppBar(context, title: translate('forgot_password_reset_password')),
            body: SingleChildScrollView(
              padding: paddingHorizontal,
              child: renderForm(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: renderNewPassword(translate: translate),
                    ),
                    renderConfirm(translate: translate),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!loading && _formKey.currentState!.validate()) {
                            submit();
                          }
                        },
                        child: loading
                            ? SpinKitThreeBounce(
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 20.0,
                              )
                            : Text(translate('change_password_save')),
                      ),
                    )
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

  Widget renderNewPassword({required TranslateType translate}) {
    return TextFormField(
      controller: _txtNewPassword,
      focusNode: _newPasswordFocusNode,
      validator: (value) => changePassword(
        value: value!,
        errorPassNew: translate('change_password_old_required'),
        errorCharInLength: translate('validate_characters_in_length',{'length': '6'}),
        errorUpperCase: translate('validate_one_upper_case'),
        errorLowerCase: translate('validate_one_lower_case'),
        errorDigit: translate('validate_one_digit'),
        errorSpecial: translate('validate_one_special_character'),
        errorNewDiffOld: translate('change_password_new_diff_old'),
      ),
      obscureText: obscureTextNewPassword,
      decoration: InputDecoration(
        labelText: translate('change_password_new'),
        suffixIcon: IconButton(
          iconSize: 16,
          icon: Icon(obscureTextNewPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          onPressed: () => updateObscure('new_password'),
        ),
      ),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
      },
    );
  }

  Widget renderConfirm({required TranslateType translate}) {
    return TextFormField(
      controller: _txtConfirmPassword,
      focusNode: _confirmPasswordFocusNode,
      validator: (value) {
        if (value!.isEmpty) {
          return translate('change_password_confirm_required');
        }
        if (value != _txtNewPassword.text) {
          return translate('change_password_confirm_same_new');
        }
        return null;
      },
      obscureText: obscureTextConfirmPassword,
      decoration: InputDecoration(
        labelText: translate('change_password_confirm'),
        suffixIcon: IconButton(
          iconSize: 16,
          icon: Icon(obscureTextConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          onPressed: () => updateObscure('confirm_password'),
        ),
      ),
    );
  }
}
