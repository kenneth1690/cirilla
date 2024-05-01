import 'package:json_annotation/json_annotation.dart';

import 'message.dart';
import 'user.dart';

part 'chat.g.dart';

@JsonSerializable(createToJson: false)
class BMChat {

  @JsonKey(name: "thread_id")
  int? id;

  String? title;

  @JsonKey(fromJson: _fromMessage)
  List<BMMessage>? messages;

  @JsonKey(fromJson: _fromUser)
  List<BMUser>? participants;

  int? participantsCount;

  int? unread;

  BMChat({
    this.id,
    this.title,
    this.participants,
    this.participantsCount,
    this.messages,
    this.unread,
  });

  factory BMChat.fromJson(Map<String, dynamic> json) => _$BMChatFromJson(json);

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

  static List<BMMessage>? _fromMessage(dynamic value) {
    if (value is List) {
      return value.map((m) => BMMessage.fromJson(m)).toList().cast<BMMessage>();
    }
    return null;
  }
}