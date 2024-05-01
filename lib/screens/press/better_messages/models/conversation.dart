import 'package:json_annotation/json_annotation.dart';

import 'message.dart';
import 'user.dart';

part 'conversation.g.dart';

@JsonSerializable(createToJson: false)
class BMConversation {

  @JsonKey(name: "thread_id")
  int? id;

  String? title;

  String? lastTime;

  @JsonKey(fromJson: _fromMessage)
  BMMessage? lastMessage;

  @JsonKey(fromJson: _fromUser)
  List<BMUser>? participants;

  int? participantsCount;

  int? unread;


  BMConversation({
    this.id,
    this.title,
    this.lastTime,
    this.participants,
    this.participantsCount,
    this.lastMessage,
    this.unread,
  });

  factory BMConversation.fromJson(Map<String, dynamic> json) => _$BMConversationFromJson(json);

  static List<BMUser>? _fromUser(dynamic value) {
    if (value is List && value.isNotEmpty) {
      return value
          .map((v) {
        return BMUser.fromJson(v);
      })
          .toList()
          .cast<BMUser>();
    }
    return [] as List<BMUser>;
  }

  static BMMessage? _fromMessage(dynamic value) {
    if (value is Map ) {
      return BMMessage.fromJson(value.cast());
    }
    return null;
  }
}