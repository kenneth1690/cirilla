// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BMChat _$BMChatFromJson(Map<String, dynamic> json) => BMChat(
      id: json['thread_id'] as int?,
      title: json['title'] as String?,
      participants: BMChat._fromUser(json['participants']),
      participantsCount: json['participantsCount'] as int?,
      messages: BMChat._fromMessage(json['messages']),
      unread: json['unread'] as int?,
    );
