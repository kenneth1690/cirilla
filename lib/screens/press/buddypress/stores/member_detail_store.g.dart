// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_detail_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BPMemberDetailStore on BPMemberDetailStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'BPMemberDetailStoreBase.loading'))
      .value;
  Computed<BPMember?>? _$memberComputed;

  @override
  BPMember? get member =>
      (_$memberComputed ??= Computed<BPMember?>(() => super.member,
              name: 'BPMemberDetailStoreBase.member'))
          .value;
  Computed<String?>? _$bannerComputed;

  @override
  String? get banner =>
      (_$bannerComputed ??= Computed<String?>(() => super.banner,
              name: 'BPMemberDetailStoreBase.banner'))
          .value;
  Computed<String?>? _$errorMessageComputed;

  @override
  String? get errorMessage =>
      (_$errorMessageComputed ??= Computed<String?>(() => super.errorMessage,
              name: 'BPMemberDetailStoreBase.errorMessage'))
          .value;

  late final _$_idAtom =
      Atom(name: 'BPMemberDetailStoreBase._id', context: context);

  @override
  int? get _id {
    _$_idAtom.reportRead();
    return super._id;
  }

  @override
  set _id(int? value) {
    _$_idAtom.reportWrite(value, super._id, () {
      super._id = value;
    });
  }

  late final _$_memberAtom =
      Atom(name: 'BPMemberDetailStoreBase._member', context: context);

  @override
  BPMember? get _member {
    _$_memberAtom.reportRead();
    return super._member;
  }

  @override
  set _member(BPMember? value) {
    _$_memberAtom.reportWrite(value, super._member, () {
      super._member = value;
    });
  }

  late final _$_bannerAtom =
      Atom(name: 'BPMemberDetailStoreBase._banner', context: context);

  @override
  String? get _banner {
    _$_bannerAtom.reportRead();
    return super._banner;
  }

  @override
  set _banner(String? value) {
    _$_bannerAtom.reportWrite(value, super._banner, () {
      super._banner = value;
    });
  }

  late final _$_loadingAtom =
      Atom(name: 'BPMemberDetailStoreBase._loading', context: context);

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

  late final _$_errorMessageAtom =
      Atom(name: 'BPMemberDetailStoreBase._errorMessage', context: context);

  @override
  String? get _errorMessage {
    _$_errorMessageAtom.reportRead();
    return super._errorMessage;
  }

  @override
  set _errorMessage(String? value) {
    _$_errorMessageAtom.reportWrite(value, super._errorMessage, () {
      super._errorMessage = value;
    });
  }

  late final _$getDataAsyncAction =
      AsyncAction('BPMemberDetailStoreBase.getData', context: context);

  @override
  Future<void> getData() {
    return _$getDataAsyncAction.run(() => super.getData());
  }

  @override
  String toString() {
    return '''
loading: ${loading},
member: ${member},
banner: ${banner},
errorMessage: ${errorMessage}
    ''';
  }
}
