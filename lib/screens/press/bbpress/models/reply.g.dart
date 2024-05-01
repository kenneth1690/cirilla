// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BBPReply _$BBPReplyFromJson(Map<String, dynamic> json) => BBPReply(
      id: json['id'] as int?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      parent: json['reply_to'] as int?,
      authorName: json['author_name'] as String?,
      authorAvatar: BBPReply._fromAvatar(json['author_avatar']),
      date: json['post_date'] as String?,
    );
