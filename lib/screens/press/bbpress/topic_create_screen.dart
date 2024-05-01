import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/models.dart';

class BBPTopicCreateScreen extends StatefulWidget {
  final BBPForum forum;
  final String? email;
  final Function callback;

  const BBPTopicCreateScreen({
    super.key,
    required this.forum,
    this.email,
    required this.callback,
  });

  @override
  State<BBPTopicCreateScreen> createState() => _BBPTopicCreateScreenState();
}

class _BBPTopicCreateScreenState extends State<BBPTopicCreateScreen> with AppBarMixin, LoadingMixin, SnackMixin {
  late SettingStore _settingStore;

  final _formKey = GlobalKey<FormState>();

  final _txtTitle = TextEditingController();
  final _txtContent = TextEditingController();

  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingStore = Provider.of<SettingStore>(context);
  }

  @override
  void dispose() {
    _txtTitle.dispose();
    _txtContent.dispose();
    // _txtTag.dispose();
    super.dispose();
  }

  void _handleCreateTopic(TranslateType translate) async {
    try {
      setState(() {
        _loading = true;
      });
      Map<String, dynamic> data = {
        "title": _txtTitle.text,
        "content": _txtContent.text,
        "email": widget.email,
      };
      await _settingStore.requestHelper.createTopic(
        idForum: widget.forum.id ?? 0,
        data: data,
      );
      setState(() {
        _loading = false;
      });
      if (mounted) showSuccess(context, translate("bbpress_create_topic_success"));
      widget.callback();
    } catch (e) {
      setState(() {
        _loading = false;
      });
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslateType translate = AppLocalizations.of(context)!.translate;

    return Scaffold(
      appBar: baseStyleAppBar(
        context,
        title: translate("bbpress_create_topic"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _txtTitle,
                decoration: InputDecoration(
                  labelText: translate("bbpress_create_topic_title"),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return translate("buddypress_validate_empty");
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
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
                    color: Theme.of(context).colorScheme.onPrimary,
                  )
                      : Text(translate("bbpress_create_topic_submit")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
