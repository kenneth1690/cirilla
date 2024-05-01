// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ResetPasswordStore on ResetPasswordStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'ResetPasswordStoreBase.loading'))
      .value;
  Computed<bool>? _$loadingVerifyComputed;

  @override
  bool get loadingVerify =>
      (_$loadingVerifyComputed ??= Computed<bool>(() => super.loadingVerify,
              name: 'ResetPasswordStoreBase.loadingVerify'))
          .value;
  Computed<bool>? _$loadingUpdateComputed;

  @override
  bool get loadingUpdate =>
      (_$loadingUpdateComputed ??= Computed<bool>(() => super.loadingUpdate,
              name: 'ResetPasswordStoreBase.loadingUpdate'))
          .value;

  late final _$_loadingAtom =
      Atom(name: 'ResetPasswordStoreBase._loading', context: context);

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

  late final _$_loadingVerifyAtom =
      Atom(name: 'ResetPasswordStoreBase._loadingVerify', context: context);

  @override
  bool get _loadingVerify {
    _$_loadingVerifyAtom.reportRead();
    return super._loadingVerify;
  }

  @override
  set _loadingVerify(bool value) {
    _$_loadingVerifyAtom.reportWrite(value, super._loadingVerify, () {
      super._loadingVerify = value;
    });
  }

  late final _$_loadingUpdateAtom =
      Atom(name: 'ResetPasswordStoreBase._loadingUpdate', context: context);

  @override
  bool get _loadingUpdate {
    _$_loadingUpdateAtom.reportRead();
    return super._loadingUpdate;
  }

  @override
  set _loadingUpdate(bool value) {
    _$_loadingUpdateAtom.reportWrite(value, super._loadingUpdate, () {
      super._loadingUpdate = value;
    });
  }

  late final _$ResetPasswordAppAsyncAction = AsyncAction(
      'ResetPasswordStoreBase.ResetPasswordApp',
      context: context);

  @override
  Future<Map<String, dynamic>> resetPassword(String? userLogin) {
    return _$ResetPasswordAppAsyncAction
        .run(() => super.resetPassword(userLogin));
  }

  late final _$verifyOtpResetPasswordAsyncAction = AsyncAction(
      'ResetPasswordStoreBase.verifyOtpResetPassword',
      context: context);

  @override
  Future<Map<String, dynamic>> verifyOtpResetPassword(
      {required String userLogin, required int otp}) {
    return _$verifyOtpResetPasswordAsyncAction.run(
        () => super.verifyOtpResetPassword(userLogin: userLogin, otp: otp));
  }

  late final _$updatePasswordAsyncAction =
      AsyncAction('ResetPasswordStoreBase.updatePassword', context: context);

  @override
  Future<Map<String, dynamic>> updatePassword(
      {required String token, required String newPassWord}) {
    return _$updatePasswordAsyncAction.run(
        () => super.updatePassword(token: token, newPassWord: newPassWord));
  }

  @override
  String toString() {
    return '''
loading: ${loading},
loadingVerify: ${loadingVerify},
loadingUpdate: ${loadingUpdate}
    ''';
  }
}
