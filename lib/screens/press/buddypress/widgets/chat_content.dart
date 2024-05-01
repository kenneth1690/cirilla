import 'package:cirilla/constants/constants.dart';
import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as flutter_chat_types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_html/style.dart';

class ChatContentWidget extends StatefulWidget {
  final List<flutter_chat_types.Message> data;
  final void Function(flutter_chat_types.PartialText) handleChat;
  final String userId;

  const ChatContentWidget({
    Key? key,
    required this.data,
    required this.handleChat,
    required this.userId,
  }) : super(key: key);

  @override
  State<ChatContentWidget> createState() => _ChatContentWidgetState();
}

class _ChatContentWidgetState extends State<ChatContentWidget> with LoadingMixin {
  List<flutter_chat_types.Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  late FocusNode _focus;
  bool _showButtonSend = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _focus = FocusNode();
    _controller.addListener(() {
      if (_controller.text.isNotEmpty && !_showButtonSend) {
        setState(() {
          _showButtonSend = true;
        });
      }
      if (_controller.text.isEmpty && _showButtonSend) {
        setState(() {
          _showButtonSend = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focus.dispose();
  }

  void _handleMessageTap(BuildContext context, flutter_chat_types.Message message) async {
    if (message is flutter_chat_types.FileMessage) {
      // await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
      flutter_chat_types.TextMessage message,
      flutter_chat_types.PreviewData previewData,
      ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as flutter_chat_types.TextMessage).copyWith(
      previewData: previewData,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  void _loadMessages() async {
    setState(() {
      _messages = widget.data;
    });
  }

  Widget customMessageBuilder(flutter_chat_types.CustomMessage mess, {required int messageWidth}) {
    return SizedBox(
      width: 100,
      height: 50,
      child: entryLoading(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ChatTheme chatTheme = DefaultChatTheme(
      backgroundColor: theme.scaffoldBackgroundColor,
      primaryColor: theme.primaryColor,
      secondaryColor: theme.colorScheme.surface,
      inputBackgroundColor: Colors.transparent,
      sentMessageCaptionTextStyle:
      theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onPrimary) ?? TextStyle(color: theme.colorScheme.onPrimary),
      sentMessageBodyTextStyle:
      theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary) ?? TextStyle(color: theme.colorScheme.onPrimary),
      sentMessageLinkTitleTextStyle:
      theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onPrimary) ?? TextStyle(color: theme.colorScheme.onPrimary),
      sentMessageLinkDescriptionTextStyle:
      theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary) ?? TextStyle(color: theme.colorScheme.onPrimary),
      receivedMessageBodyTextStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.titleMedium?.color) ??
          TextStyle(color: theme.textTheme.titleMedium?.color),
      receivedMessageCaptionTextStyle: theme.textTheme.titleSmall ?? const TextStyle(),
      receivedMessageLinkDescriptionTextStyle:
      theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.titleMedium?.color) ??
          TextStyle(color: theme.textTheme.titleMedium?.color),
      receivedMessageLinkTitleTextStyle: theme.textTheme.titleMedium ?? const TextStyle(),
      dateDividerTextStyle: theme.textTheme.bodySmall ?? const TextStyle(),
      emptyChatPlaceholderTextStyle: theme.textTheme.bodySmall ?? const TextStyle(),
      inputContainerDecoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: borderRadiusBottomSheetLarge,
      ),
      inputTextColor: theme.textTheme.titleMedium?.color ?? Colors.black,
      inputTextStyle: theme.textTheme.bodyMedium ?? const TextStyle(),
      inputTextDecoration: const InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );

    return Chat(
      customMessageBuilder: customMessageBuilder,
      textMessageBuilder: (flutter_chat_types.TextMessage data, {required int messageWidth, required bool showName}) {
        TextStyle textStyle = data.author.id == widget.userId
            ? chatTheme.sentMessageBodyTextStyle
            : chatTheme.receivedMessageBodyTextStyle;
        Style style = Style(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          fontFamily: textStyle.fontFamily,
          fontSize: FontSize(textStyle.fontSize),
          fontWeight: textStyle.fontWeight,
          lineHeight: LineHeight(textStyle.height),
          color: textStyle.color,
        );

        return Container(
          constraints: BoxConstraints(maxWidth: messageWidth.toDouble()),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: CirillaHtml(
            html: data.text,
            style: {
              "html": style,
              "body": style,
              "div": style,
              "p": style,
            },
            shrinkWrap: true,
          ),
        );
      },
      messages: widget.data,
      // onAttachmentPressed: _handleAtachmentPressed,
      onMessageTap: _handleMessageTap,
      onPreviewDataFetched: _handlePreviewDataFetched,
      onSendPressed: widget.handleChat,
      user: flutter_chat_types.User(id: widget.userId),
      showUserAvatars: true,
      l10n: const ChatL10nEn(emptyChatPlaceholder: '...'),
      theme: chatTheme,
    );
  }
}
