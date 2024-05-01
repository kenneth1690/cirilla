// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BPConversation _$BPConversationFromJson(Map<String, dynamic> json) =>
    BPConversation(
      id: json['id'] as int?,
      title: BPConversation._fromRendered(json['subject']),
      message: BPConversation._fromRendered(json['excerpt']),
      date: convertToDate(json['date_gmt']),
      unreadCount: json['unread_count'] as int?,
      senderIds: BPConversation._fromSenderIds(json['sender_ids']),
      starredMessageIds:
          BPConversation._fromStarredMessageIds(json['starred_message_ids']),
      recipients: BPConversation._fromRecipients(json['recipients']),
    );
