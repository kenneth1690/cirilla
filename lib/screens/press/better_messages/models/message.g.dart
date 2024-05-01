// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BMMessage _$BMMessageFromJson(Map<String, dynamic> json) => BMMessage(
      id: json['message_id'] as int?,
      threadId: json['thread_id'] as int?,
      senderId: json['sender_id'] as int?,
      message: json['message'] as String?,
      date: json['date_sent'] as String?,
    );
