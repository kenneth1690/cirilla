import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReplyData {
  final int idTopic;
  final String titleTopic;
  final int? idReply;

  ReplyData({
    required this.idTopic,
    required this.titleTopic,
    this.idReply,
  });
}

class BBPReplyCreateScreen extends StatefulWidget {
  final ReplyData data;
  final String? email;
  final Function callback;

  const BBPReplyCreateScreen({
    super.key,
    required this.data,
    this.email,
    required this.callback,
  });

  @override
  State<BBPReplyCreateScreen> createState() => _BBPReplyCreateScreenState();
}

class _BBPReplyCreateScreenState extends State<BBPReplyCreateScreen> with AppBarMixin, LoadingMixin, SnackMixin {
  late SettingStore _settingStore;

  final _formKey = GlobalKey<FormState>();

  final _txtContent = TextEditingController();

  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingStore = Provider.of<SettingStore>(context);
  }

  @override
  void dispose() {
    _txtContent.dispose();
    super.dispose();
  }

  void _handleCreateTopic(TranslateType translate) async {
    try {
      setState(() {
        _loading = true;
      });
      Map<String, dynamic> data = {
        "content": _txtContent.text,
        "email": widget.email,
      };
      if (widget.data.idReply != null) {
        await _settingStore.requestHelper.createReply(
          idReply: widget.data.idReply!,
          data: data,
        );
      } else {
        await _settingStore.requestHelper.createReplyTopic(
          idTopic: widget.data.idTopic,
          data: data,
        );
      }
      setState(() {
        _loading = false;
      });
      widget.callback();
      if (mounted) showSuccess(context, translate("bbpress_create_reply_success"));
    } catch (e) {
      setState(() {
        _loading = false;
      });
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Column(
      children: [
        Text(translate("bbpress_reply"), style: theme.textTheme.titleMedium),
        Container(
          width: double.infinity,
          color: theme.colorScheme.surface,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          margin: const EdgeInsets.only(top: 16, bottom: 4),
          child: RichText(
            text: TextSpan(
              text: translate("bbpress_reply"),
              children: [
                const TextSpan(text: " "),
                if (widget.data.idReply != null) ...[
                  TextSpan(text: "#${widget.data.idReply}", style: TextStyle(color: theme.textTheme.titleSmall?.color)),
                  const TextSpan(text: " "),
                ],
                TextSpan(text: translate("bbpress_in")),
                const TextSpan(text: " "),
                TextSpan(text: widget.data.titleTopic, style: TextStyle(color: theme.textTheme.titleSmall?.color)),
              ],
              style: theme.textTheme.titleSmall?.copyWith(color: theme.textTheme.labelSmall?.color)
            ),
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _txtContent,
                    decoration: InputDecoration(
                      labelText: translate("bbpress_create_topic_content"),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return translate("buddypress_validate_empty");
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_loading && _formKey.currentState!.validate()) {
                          _handleCreateTopic(translate);
                        }
                      },
                      child: _loading
                          ? entryLoading(
                        context,
                        color: theme.colorScheme.onPrimary,
                      )
                          : Text(translate("bbpress_create_topic_submit")),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
