import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../utils.dart';

part 'group.g.dart';

@JsonSerializable(createToJson: false)
class BPGroup {
  int? id;

  @JsonKey(name: 'creator_id')
  int? creatorId;

  @JsonKey(name: 'parent_id')
  int? parentId;

  String? name;

  String? status;

  @JsonKey(name: "date_created_gmt", fromJson: convertToDate)
  DateTime? createdAt;

  @JsonKey(name: "created_since")
  String? createdSince;

  @JsonKey(name: "last_activity_gmt", fromJson: convertToDate)
  DateTime? lastActivity;

  @JsonKey(name: "total_member_count", fromJson: ConvertData.stringToInt)
  int? memberCount;

  @JsonKey(name: 'avatar_urls', fromJson: _fromAvatarUrls)
  String? avatar;

  @JsonKey(fromJson: _fromDescription)
  String? description;

  BPGroup({
    this.id,
    this.creatorId,
    this.parentId,
    this.name,
    this.status,
    this.createdAt,
    this.createdSince,
    this.avatar,
    this.lastActivity,
    this.memberCount,
    this.description,
  });

  factory BPGroup.fromJson(Map<String, dynamic> json) => _$BPGroupFromJson(json);

  static String? _fromAvatarUrls(dynamic value) {
    return get(value, ["full"]) as String?;
  }

  static String? _fromDescription(dynamic value) {
    return get(value, ["rendered"]) as String?;
  }
}
