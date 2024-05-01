import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:cirilla/types/types.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateActivityGroupFormWidget extends StatefulWidget {
  final int? id;
  final Function callback;

  const UpdateActivityGroupFormWidget({
    super.key,
    this.id,
    required this.callback,
  });

  @override
  State<UpdateActivityGroupFormWidget> createState() => _UpdateActivityGroupFormWidgetState();
}

class _UpdateActivityGroupFormWidgetState extends State<UpdateActivityGroupFormWidget> with AppBarMixin, LoadingMixin, SnackMixin {
  late SettingStore _settingStore;
  late AuthStore _authStore;

  final _formKey = GlobalKey<FormState>();

  final _txtContent = TextEditingController();

  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingStore = Provider.of<SettingStore>(context);
    _authStore = Provider.of<AuthStore>(context);
  }

  @override
  void dispose() {
    _txtContent.dispose();
    super.dispose();
  }

  void _handleCreateComment(TranslateType translate) async {
    try {
      setState(() {
        _loading = true;
      });
      Map<String, dynamic> data = {
        "context": 'edit',
        "user_id": _authStore.user?.id,
        "component": 'groups',
        "type": 'activity_update',
        "content": _txtContent.text,
        "primary_item_id": widget.id,
        "secondary_item_id": 0,
      };
      await _settingStore.requestHelper.createActivity(
        data: data,
      );
      setState(() {
        _loading = false;
      });
      widget.callback();
      if (mounted) {
        showSuccess(
            context,
            translate("buddypress_group_update_activity_success"),
        );
      }
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

    return Scaffold(
      appBar: baseStyleAppBar(
          context,
          title: translate("buddypress_group_update_activity")
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _txtContent,
                decoration: InputDecoration(
                  labelText: translate("buddypress_content"),
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
                      _handleCreateComment(translate);
                    }
                  },
                  child: _loading
                      ? entryLoading(
                    context,
                    color: theme.colorScheme.onPrimary,
                  )
                      : Text(translate("buddypress_post")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
