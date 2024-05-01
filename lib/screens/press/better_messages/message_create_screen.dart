import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../buddypress/buddypress.dart';
import 'models/models.dart';

import '../buddypress/widgets/widgets.dart';
import 'widgets/widgets.dart';

class BMMessageCreateScreen extends StatefulWidget {
  final bool enablePrivateMessage;
  final BPMember? member;
  final List<BMConversation> conversations;
  final Function(BMConversation? value) callback;

  const BMMessageCreateScreen({
    super.key,
    this.enablePrivateMessage = false,
    this.member,
    this.conversations = const [],
    required this.callback,
  });

  @override
  State<BMMessageCreateScreen> createState() => _ChatBuddyMessageListState();
}

class _ChatBuddyMessageListState extends State<BMMessageCreateScreen> with AppBarMixin, LoadingMixin, SnackMixin {
  late SettingStore _settingStore;

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
    _settingStore = Provider.of<SettingStore>(context);
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
        "subject": _txtSubject.text,
        "message": _txtMessage.text,
        "recipients": _send.map((e) => e.id).toList(),
      };
      await _settingStore.requestHelper.createConversationBM(
        data: data,
        queryParameters: {
          "nocache": DateTime.now().millisecondsSinceEpoch
        }
      );
      setState(() {
        _loading = false;
      });
      widget.callback(null);
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

    List conversations = _send.length == 1 ? widget.conversations.where((e) => (e.participants?.indexWhere((p) => p.userId == _send[0].id) ?? -1) > -1).toList() : [];
    return Scaffold(
      appBar: baseStyleAppBar(
        context,
        title: widget.enablePrivateMessage ? translate("buddypress_private_message"): translate("bm_create_conversation"),
        actions: [
          SizedBox(
            height: 34,
            child: TextButton(onPressed: _handleReset, child: Text(translate("buddypress_compose_reset"))),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: GestureDetector(
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
          ),),
          if (conversations.isNotEmpty) ...[
            const Divider(height: 1, thickness: 1),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Text(translate("bm_current_conversation", {"name": _send.isNotEmpty == true ? _send[0].name ?? "" : ""}), style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          ...List.generate(conversations.length, (index) {
                            return BMConversationItemWidget(
                              conversation: conversations[index],
                              onTap: () => widget.callback(conversations[index]),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
