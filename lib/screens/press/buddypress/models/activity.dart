import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../utils.dart';

part 'activity.g.dart';

@JsonSerializable(createToJson: false)
class BPActivity {

  int? id;

  @JsonKey(fromJson: _fromContent)
  String? content;

  @JsonKey(name: 'date_gmt', fromJson: convertToDate)
  DateTime? date;

  bool? favorited;

  String? type;

  String? status;

  @JsonKey(name: "user_id")
  int? authorId;

  String? title;

  @JsonKey(name: "user_avatar", fromJson: _fromAvatarUrls)
  String? authorAvatar;

  @JsonKey(name: "comment_count")
  int? commentCount;

  @JsonKey(name: "comments")
  List<BPActivity>? comments;

  @JsonKey(name: "primary_item_id")
  int? primaryId;

  @JsonKey(name: "secondary_item_id")
  int? secondaryId;

  BPActivity({
    this.id,
    this.content,
    this.date,
    this.favorited,
    this.type,
    this.status,
    this.authorId,
    this.title,
    this.authorAvatar,
    this.commentCount,
    this.comments,
    this.primaryId,
    this.secondaryId,
  });

  factory BPActivity.fromJson(Map<String, dynamic> json) => _$BPActivityFromJson(json);

  static String? _fromContent(dynamic value) {
    return get(value, ["rendered"]) as String?;
  }

  static String? _fromAvatarUrls(dynamic value) {
    String? imageLink = get(value, ["full"]) as String?;
    return imageLink?.isNotEmpty == true ? imageLink!.contains("https:") ? imageLink : "https:$imageLink": imageLink;
  }
}