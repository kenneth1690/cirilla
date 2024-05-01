import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/models/models.dart';
import 'package:cirilla/service/helpers/request_helper.dart';
import 'package:cirilla/store/setting/setting_store.dart';
import 'package:cirilla/utils/convert_data.dart';
import 'package:dio/dio.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';
import 'package:provider/provider.dart';

class SubscribeWidget extends StatefulWidget {
  final WidgetConfig? widgetConfig;

  const SubscribeWidget({
    Key? key,
    required this.widgetConfig,
  }) : super(key: key);

  @override
  State<SubscribeWidget> createState() => _SubscribeWidgetState();
}

class _SubscribeWidgetState extends State<SubscribeWidget>
    with Utility, NavigationMixin, SnackMixin, LoadingMixin, ContainerMixin {
  final _emailController = TextEditingController();
  bool _loading = false;
  bool _validateEmail = false;
  late SettingStore settingStore;
  late String themeModeKey;
  late String languageKey;
  late String imageKey;
  late RequestHelper requestHelper;
  @override
  void didChangeDependencies() {
    settingStore = Provider.of<SettingStore>(context);
    themeModeKey = settingStore.themeModeKey;
    languageKey = settingStore.languageKey;
    imageKey = settingStore.imageKey;
    requestHelper = Provider.of<RequestHelper>(context);
    super.didChangeDependencies();
  }

  void onPressed(BuildContext context, String? formId, String nameKey) async {
    setState(() {
      _emailController.text.isEmpty ? _validateEmail = true : _validateEmail = false;
    });
    if (mounted) FocusScope.of(context).unfocus();
    if (!_validateEmail) {
      setState(() {
        _loading = true;
      });
      try {
        Map<String, dynamic> res = await requestHelper.sendContact(queryParameters: {
          nameKey: _emailController.text,
        }, formId: formId);
        if (res['status'] != 'mail_sent') {
          if (context.mounted) showError(context, res['message']);
        } else {
          if (context.mounted) showSuccess(context, res['message']);
        }
        setState(() {
          _emailController.clear();
          _loading = false;
        });
      } on DioException catch (e) {
        if (context.mounted) showError(context, e);
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;
    /// Config general
    Map<String, dynamic> headingData = widget.widgetConfig?.fields ?? {};
    String text = ConvertData.textFromConfigs(headingData['title'], languageKey);
    TextStyle titleStyle = ConvertData.toTextStyle(get(headingData, ['title'], ''), themeModeKey);
    String description = ConvertData.textFromConfigs(headingData['description'], languageKey);
    TextStyle descriptionStyle = ConvertData.toTextStyle(get(headingData, ['description'], ''), themeModeKey);
    String placeHolder = ConvertData.textFromConfigs(headingData['placeholder'], languageKey);
    String textButton = ConvertData.textFromConfigs(headingData['txtButton'], languageKey);

    String? formId = get(headingData, ['formId'], '');

    String nameKey = get(headingData, ['name'], 'your-email');

    /// Styles
    Map<String, dynamic> styles = widget.widgetConfig?.styles ?? {};
    Color background = ConvertData.fromRGBA(get(styles, ['background', themeModeKey], {}), Colors.transparent);
    Map? padding = get(styles, ['padding'], {});
    Map? margin = get(styles, ['margin'], {});
    String? image = ConvertData.imageFromConfigs(get(styles, ['image']), imageKey);

    Color colorIcon =
        ConvertData.fromRGBA(get(styles, ['colorIcon', themeModeKey], {}), textTheme.titleMedium?.color);
    double sizeIcon = ConvertData.stringToDouble(get(styles, ['sizeIcon'], 20), 20);

    Color backgroundButton =
        ConvertData.fromRGBA(get(styles, ['backgroundButton', themeModeKey], {}), theme.primaryColor);
    Color colorButton = ConvertData.fromRGBA(get(styles, ['colorButton', themeModeKey], {}), Colors.white);

    Color backgroundInput =
        ConvertData.fromRGBA(get(styles, ['backgroundInput', themeModeKey], {}), Colors.transparent);
    Color colorInput =
        ConvertData.fromRGBA(get(styles, ['colorInput', themeModeKey], {}), textTheme.titleMedium?.color);
    Color colorPlaceholder =
        ConvertData.fromRGBA(get(styles, ['colorPlaceholder', themeModeKey], {}), textTheme.bodyMedium?.color);
    Color borderInput = ConvertData.fromRGBA(get(styles, ['borderInput', themeModeKey], {}), theme.dividerColor);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        padding: ConvertData.space(padding, 'padding'),
        margin: ConvertData.space(margin, 'margin'),
        decoration: decorationColorImage(color: background, image: image),
        width: double.infinity,
        child: SubscribeItem(
          icon: Icon(
            FeatherIcons.mail,
            size: sizeIcon,
            color: colorIcon,
          ),
          title: Text(
            text,
            style: textTheme.titleLarge?.merge(titleStyle),
          ),
          content: Text(
            description,
            style: textTheme.bodyMedium?.merge(descriptionStyle),
            textAlign: TextAlign.center,
          ),
          textField: TextFormField(
            controller: _emailController,
            onChanged: (value) {
              setState(() {
                _validateEmail = false;
              });
            },
            decoration: InputDecoration(
              hintText: placeHolder,
              hintStyle: textTheme.bodyLarge?.copyWith(color: colorPlaceholder),
              errorText: _validateEmail ? '$placeHolder is required' : null,
              filled: true,
              fillColor: backgroundInput,
              labelStyle: textTheme.bodyLarge,
              contentPadding: const EdgeInsetsDirectional.only(start: 16, bottom: 2),
              focusedBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: borderInput),
              ),
              enabledBorder: UnderlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: borderInput),
              ),
            ),
            cursorColor: colorInput,
            style: textTheme.bodyLarge?.copyWith(color: colorInput),
          ),
          elevatedButton: ElevatedButton(
            onPressed: () => onPressed(context, formId, nameKey),
            style: ElevatedButton.styleFrom(
              foregroundColor: colorButton,
              backgroundColor: backgroundButton,
            ),
            child: _loading ? entryLoading(context, color: theme.colorScheme.onPrimary) : Text(textButton),
          ),
        ),
      ),
    );
  }
}
