import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/models.dart';
import 'stores/stores.dart';

import 'widgets/widgets.dart';

class BPChatCreateScreen extends StatefulWidget {
  final bool enablePrivateMessage;
  final BPMember? member;
  final Function callback;

  const BPChatCreateScreen({
    super.key,
    this.enablePrivateMessage = false,
    this.member,
    required this.callback,
  });

  @override
  State<BPChatCreateScreen> createState() => _ChatBuddyMessageListState();
}

class _ChatBuddyMessageListState extends State<BPChatCreateScreen> with AppBarMixin, LoadingMixin, SnackMixin {
  late AuthStore _authStore;
  late SettingStore _settingStore;
  late BPMessageStore _messageStore;

  final _formKey = GlobalKey<FormState>();

  late List<BPMember> _send;
  final _txtSubject = TextEditingController();
  final _txtMessage = TextEditingController();

  FocusNode? _messageFocusNode;

  bool _loading = false;

  @override
  void initState() {
    _send = widget.member != null ? [widget.member!] : [];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authStore = Provider.of<AuthStore>(context);
    _settingStore = Provider.of<SettingStore>(context);
    _messageStore = BPMessageStore(_settingStore.requestHelper);
  }

  @override
  void dispose() {
    _txtSubject.dispose();
    _txtMessage.dispose();
    _messageFocusNode?.dispose();
    super.dispose();
  }

  void _handleChat(TranslateType translate) async {
    try {
      setState(() {
        _loading = true;
      });
      Map<String, dynamic> data = {
        "context": "edit",
        "subject": _txtSubject.text,
        "message": _txtMessage.text,
        "recipients": _send.map((e) => e.id).toList(),
        "sender_id": _authStore.user?.id,
      };
      await _messageStore.createMessage(
        data: data,
      );
      setState(() {
        _loading = false;
      });
      if (mounted) showSuccess(context, widget.enablePrivateMessage ? translate("buddypress_create_private_message_success"): translate("buddypress_compose_success"));
      widget.callback();
    } catch (e) {
      setState(() {
        _loading = false;
      });
      if (mounted) showError(context, e);
    }
  }

  void _handleReset() async {
    if (!_loading) {
      _txtMessage.clear();
      _txtSubject.clear();
      setState(() {
        _send = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Scaffold(
      appBar: baseStyleAppBar(
        context,
        title: widget.enablePrivateMessage ? translate("buddypress_private_message"): translate("buddypress_compose"),
        actions: [
          SizedBox(
            height: 34,
            child: TextButton(onPressed: _handleReset, child: Text(translate("buddypress_compose_reset"))),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          if (FocusScope.of(context).hasFocus) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ChatSendFieldWidget(
                  users: _send,
                  onchangeUser: (List<BPMember> data) => setState(() {
                    _send = data;
                  }),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _txtSubject,
                  decoration: InputDecoration(
                    labelText: translate("buddypress_compose_subject"),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return translate("buddypress_validate_empty");
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_messageFocusNode);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _txtMessage,
                  focusNode: _messageFocusNode,
                  decoration: InputDecoration(
                    labelText: translate("buddypress_compose_message"),
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
                        if (_send.isEmpty) {
                          showError(context, translate("buddypress_compose_send_empty"));
                        } else {
                          _handleChat(translate);
                        }
                      }
                    },
                    child: _loading
                        ? entryLoading(
                      context,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                        : Text(translate("buddypress_compose_send")),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
