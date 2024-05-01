import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../member_friend_screen.dart';

class MemberButtonFriendSlugWidget extends StatefulWidget {
  final int? id;
  final String slug;
  final Function(int? id, String currentType)? callback;
  final Widget Function(String title, Function onClick, bool loading) onRenderChild;

  const MemberButtonFriendSlugWidget({
    super.key,
    this.id,
    this.slug = "",
    this.callback,
    required this.onRenderChild,
  });

  @override
  State<MemberButtonFriendSlugWidget> createState() => _MemberButtonFriendSlugWidgetState();
}

class _MemberButtonFriendSlugWidgetState extends State<MemberButtonFriendSlugWidget> with LoadingMixin, TransitionMixin, SnackMixin {
  late AuthStore _authStore;
  late SettingStore _settingStore;

  bool _loading = false;

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);
    _settingStore = Provider.of<SettingStore>(context);
    super.didChangeDependencies();
  }

  String getTitle(String? slug, TranslateType translate) {
    switch (slug) {
      case "is_friend":
        return translate("buddypress_friends_cancel");
      case "pending":
        return translate("buddypress_friends_cancel_request");
      case "awaiting_response":
        return translate("buddypress_friends_requested");
      case "accept":
        return translate("buddypress_friends_accept");
      case "reject":
        return translate("buddypress_friends_reject");
      default:
        return translate("buddypress_friends_add");
    }
  }

  void onClick() {
    switch (widget.slug) {
      case "is_friend":
        removeFriend();
        break;
      case "pending":
        removeFriend();
        break;
      case "awaiting_response":
        requestFriend();
        break;
      case "accept":
        acceptFriend();
        break;
      case "reject":
        removeFriend();
        break;
      default:
        addFriend();
        break;
    }
  }

  void addFriend() async {
    try {
      setState(() {
        _loading = true;
      });
      await _settingStore.requestHelper.addFriend(
        data: {
          "context": 'edit',
          "initiator_id": _authStore.user?.id,
          "friend_id": widget.id,
        },
        queryParameters: {
          "app-builder-decode": true,
        },
      );
      widget.callback?.call(widget.id, "pending");
      setState(() {
        _loading = false;
      });
    } on DioException catch (e) {
      if (mounted) showError(context, e);
      setState(() {
        _loading = false;
      });
    }
  }

  void acceptFriend() async {
    try {
      setState(() {
        _loading = true;
      });
      await _settingStore.requestHelper.acceptFriend(
        id: widget.id ?? 0,
        queryParameters: {
          "context": "edit",
          "app-builder-decode": true,
        },
      );
      widget.callback?.call(widget.id, "is_friend");
      setState(() {
        _loading = false;
      });
    } on DioException catch (e) {
      if (mounted) showError(context, e);
      setState(() {
        _loading = false;
      });
    }
  }

  void requestFriend() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) {
          return BPMemberFriendScreen(
            store: _settingStore,
            args: {
              "id": _authStore.user?.id,
            },
            initTab: 1,
            onActionCallback: widget.callback,
          );
        },
        transitionsBuilder: slideTransition,
      ),
    );
  }

  void removeFriend() async {
    try {
      setState(() {
        _loading = true;
      });
      await _settingStore.requestHelper.removeFriend(
        id: widget.id ?? 0,
        queryParameters: {
          "force": true,
          "app-builder-decode": true,
        },
      );
      widget.callback?.call(widget.id, "not_friends");

      setState(() {
        _loading = false;
      });
    } on DioException catch (e) {
      if (mounted) showError(context, e);
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return widget.onRenderChild(getTitle(widget.slug, translate), onClick, _loading);
  }
}
