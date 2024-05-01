// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ForgotPasswordStore on ForgotPasswordStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'ForgotPasswordStoreBase.loading'))
      .value;

  late final _$_loadingAtom =
      Atom(name: 'ForgotPasswordStoreBase._loading', context: context);

  @override
  bool get _loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  set _loading(bool value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  late final _$forgotPasswordAsyncAction =
      AsyncAction('ForgotPasswordStoreBase.forgotPassword', context: context);

  @override
  Future<bool> forgotPassword(String? userLogin) {
    return _$forgotPasswordAsyncAction
        .run(() => super.forgotPassword(userLogin));
  }

  @override
  String toString() {
    return '''
loading: ${loading}
    ''';
  }
}
