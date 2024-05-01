import 'package:cirilla/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'topic.g.dart';

@JsonSerializable(createToJson: false)
class BBPTopic {
  int? id;

  String? title;

  @JsonKey(name: 'reply_count', fromJson: ConvertData.stringToInt)
  int? replyCount;

  @JsonKey(name: 'author_name')
  String? authorName;

  @JsonKey(name: 'author_avatar')
  String? authorAvatar;

  @JsonKey(name: 'post_date')
  String? date;

  @JsonKey(name: 'forum_id')
  int? forumId;

  @JsonKey(name: 'forum_title')
  String? forumTitle;

  BBPTopic({
    this.id,
    this.title,
    this.replyCount,
    this.authorName,
    this.authorAvatar,
    this.date,
    this.forumId,
    this.forumTitle,
  });

  factory BBPTopic.fromJson(Map<String, dynamic> json) => _$BBPTopicFromJson(json);
}
