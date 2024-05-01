import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forum.g.dart';

@JsonSerializable(createToJson: false)
class BBPForum {
  int? id;

  @JsonKey(fromJson: unescape)
  String? title;

  int? parent;

  @JsonKey(name: 'topic_count', fromJson: ConvertData.stringToInt)
  int? topicCount;

  @JsonKey(name: 'reply_count', fromJson: ConvertData.stringToInt)
  int? replyCount;

  String? content;

  String? type;

  BBPForum({
    this.id,
    this.title,
    this.parent,
    this.topicCount,
    this.replyCount,
    this.content,
    this.type,
  });

  factory BBPForum.fromJson(Map<String, dynamic> json) => _$BBPForumFromJson(json);
}
