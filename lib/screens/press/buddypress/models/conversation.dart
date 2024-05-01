import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';

import 'member.dart';
import '../../utils.dart';

part 'conversation.g.dart';

@JsonSerializable(createToJson: false)
class BPConversation {
  int? id;

  @JsonKey(name: 'subject', fromJson: _fromRendered)
  String? title;

  @JsonKey(name: 'excerpt', fromJson: _fromRendered)
  String? message;

  @JsonKey(name: 'date_gmt', fromJson: convertToDate)
  DateTime? date;

  @JsonKey(name: 'unread_count')
  int? unreadCount;

  @JsonKey(name: 'sender_ids', fromJson: _fromSenderIds)
  List<int>? senderIds;

  @JsonKey(name: 'starred_message_ids', fromJson: _fromStarredMessageIds)
  List<int>? starredMessageIds;

  @JsonKey(fromJson: _fromRecipients)
  List<BPMember>? recipients;

  BPConversation({
    this.id,
    this.title,
    this.message,
    this.date,
    this.unreadCount,
    this.senderIds,
    this.starredMessageIds,
    this.recipients,
  });

  factory BPConversation.fromJson(Map<String, dynamic> json) => _$BPConversationFromJson(json);

  static String? _fromRendered(dynamic value) {
    return get(value, ["rendered"]) as String?;
  }

  static List<BPMember>? _fromRecipients(dynamic value) {
    if (value is List && value.isNotEmpty) {
      return value
          .map((v) {
        return BPMember.fromJson({
          "id": ConvertData.stringToInt(get(v, ['user_id'])),
          "name": get(v, ['name']),
          'avatar_urls': get(v, ['user_avatars']),
        });
      })
          .toList()
          .cast<BPMember>();
    }
    return [] as List<BPMember>;
  }

  static List<int>? _fromSenderIds(dynamic value) {
    if (value is Map && value.isNotEmpty) {
      return value.keys.map((e) => ConvertData.stringToInt(e)).toList().cast<int>();
    }
    return ([]).cast<int>();
  }

  static List<int>? _fromStarredMessageIds(dynamic value) {
    if (value is List && value.isNotEmpty) {
      return value.map((e) => ConvertData.stringToInt(e)).toList().cast<int>();
    }
    return ([]).cast<int>();
  }
}