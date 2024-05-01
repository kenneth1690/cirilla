import 'package:cirilla/constants/styles.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/models.dart';
import 'widgets/widgets.dart';

class BPActivityCommentListScreen extends StatefulWidget {
  final int? id;
  final Function? onFetch;

  const BPActivityCommentListScreen({
    super.key,
    this.id,
    this.onFetch,
  });

  @override
  State<BPActivityCommentListScreen> createState() => _BPActivityCommentListScreenState();
}

class _BPActivityCommentListScreenState extends State<BPActivityCommentListScreen> with AppBarMixin, LoadingMixin, SnackMixin {
  late SettingStore _settingStore;
  late AuthStore _authStore;
  BPActivity? _activity;
  BPActivity? _commentReply;

  bool _loading = false;

  @override
  void didChangeDependencies() {
    _authStore = Provider.of<AuthStore>(context);
    _settingStore = Provider.of<SettingStore>(context);
    getData();
    super.didChangeDependencies();
  }

  void getData() async {
    try {
      if (widget.id != null) {
        setState(() {
          _loading = true;
        });
        BPActivity? data = await _settingStore.requestHelper.getActivity(
            id: widget.id!,
            queryParameters: {
              "display_comments": "threaded",
              "app-builder-decode": true,
            },
        );
        setState(() {
          _loading = false;
          _activity = data;
        });
      }
    } catch(e) {
      setState(() {
        _loading = false;
      });
      if (mounted) showError(context, e);
    }
  }

  void onReply() async {
    String? value = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: borderRadiusBottomSheet,
      ),
      builder: (BuildContext context) {
        double height = MediaQuery.of(context).size.height;
        return SizedBox(
          height: height - 150,
          // padding: const EdgeInsets.symmetric(vertical: 24),
          child: _CommentForm(
            data: _commentReply ?? _activity,
            callback: () => Navigator.of(context).pop("OK"),
            height: height - 150,
          ),
        );
      },
    );
    if (value == "OK") {
      getData();
      widget.onFetch?.call();
    }
    setState(() {
      _commentReply = null;
    });
  }

  Widget buildContent(
    BuildContext context,
    {
      required TranslateType translate,
    })
  {
    ThemeData theme = Theme.of(context);

    if (_loading && _activity?.id == null) {
      return entryLoading(context);
    }

    if (_activity?.id == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(translate("buddypress_comment_list_error_id")),
          GestureDetector(
            onTap: getData,
            child: Icon(Icons.refresh, size: 20, color: theme.primaryColor,),
          ),
        ],
      );
    }

    List<BPActivity> comments = _activity?.comments ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ActivityItemWidget(activity: _activity, type: ActivityItemType.noAction),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(translate("buddypress_comments"), style: theme.textTheme.titleMedium),
              GestureDetector(
                onTap: !_loading? getData : null,
                child: Icon(Icons.refresh, size: 20, color: _loading ? theme.disabledColor : theme.primaryColor,),
              ),
            ],
          ),
        ),
        Expanded(
            child: _loading ?
              entryLoading(context) :
                comments.isNotEmpty ?
                  CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (_, index) => ActivityItemWidget(
                                  activity: comments[index],
                                  callback: (data) {
                                    setState(() {
                                      _commentReply = data;
                                    });
                                    onReply();
                                  },
                                  type: ActivityItemType.comment,
                                ),
                            childCount: comments.length,
                          ),
                        ),
                      ),
                    ],
                  ) : Center(
                  child: Text(translate("buddypress_empty")),
                ),
        ),
      ],
    );

  }
  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Scaffold(
      appBar: baseStyleAppBar(
        context,
        title: "#${widget.id}",
      ),
      body: buildContent(context, translate: translate),
      bottomNavigationBar: _authStore.isLogin && !_loading ? Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: ElevatedButton(
          onPressed: onReply,
          child: Text(translate("buddypress_comment_write")),
        ),
      ) : null,
    );
  }
}

class _CommentForm extends StatelessWidget with AppBarMixin, SnackMixin {
  final BPActivity? data;
  final Function callback;
  final double height;

  const _CommentForm({
    this.data,
    required this.callback,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    int? primaryId = data?.type == "activity_comment" ? data!.primaryId : data?.id;
    int? secondaryId = data?.id;
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 4),
            child: Row(
              children: [
                Expanded(child: Container()),
                Expanded(
                  flex: 3,
                  child: Text(
                    data?.type == "activity_comment" ?
                    translate("buddypress_comment_reply", {
                      "secondaryId": "${data?.id}",
                      "primaryId": "${data?.primaryId}",
                    }) :
                    translate("buddypress_comment"),
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: leading(enableIconClose: true, color: theme.textTheme.titleMedium?.color),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ActivityFormWidget(
              primaryId: primaryId,
              secondaryId: secondaryId,
              callback: () {
                callback();
                showSuccess(
                    context,
                    translate(
                        data?.type == "activity_comment" ?
                        "buddypress_create_comment_reply_success" :
                        "buddypress_create_comment_success"
                    )
                );
              },
              height: height,
            ),
          ),
        ],
      ),
    );
  }
}