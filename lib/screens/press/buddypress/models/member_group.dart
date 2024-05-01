import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../utils.dart';

part 'member_group.g.dart';

@JsonSerializable(createToJson: false)
class BPMemberGroup {
  int? id;

  String? name;

  @JsonKey(name: "user_login")
  String? userLogin;

  @JsonKey(name: "mention_name")
  String? mentionName;

  @JsonKey(name: 'avatar_urls', fromJson: _fromAvatarUrls)
  String? avatar;

  @JsonKey(name: "is_mod")
  bool? isMod;

  @JsonKey(name: "is_admin")
  bool? isAdmin;

  @JsonKey(name: "is_banned")
  bool? isBanned;

  @JsonKey(name: "is_confirmed")
  bool? isConfirmed;

  @JsonKey(name: "date_modified_gmt", fromJson: convertToDate)
  DateTime? date;

  BPMemberGroup({
    this.id,
    this.name,
    this.userLogin,
    this.mentionName,
    this.avatar,
    this.isMod,
    this.isAdmin,
    this.isBanned,
    this.isConfirmed,
    this.date,
  });

  factory BPMemberGroup.fromJson(Map<String, dynamic> json) => _$BPMemberGroupFromJson(json);

  static String? _fromAvatarUrls(dynamic value) {
    String text = get(value, ["full"], "");
    return text.contains("http")
        ? text
        : text.isNotEmpty
        ? "https:$text"
        : null;
  }
}
