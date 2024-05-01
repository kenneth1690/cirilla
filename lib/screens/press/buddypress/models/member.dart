import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class BPMember {
  int? id;

  String? name;

  @JsonKey(name: 'user_login')
  String? userLogin;

  @JsonKey(name: 'mention_name')
  String? mentionName;

  @JsonKey(name: 'avatar_urls', fromJson: _fromAvatarUrls, toJson: _toAvatarUrls)
  String? avatar;

  @JsonKey(name: 'registered_since')
  String? registeredSince;

  @JsonKey(name: 'last_activity', fromJson: _fromLastActive, toJson: _toLastActive)
  String? lastActive;

  @JsonKey(name: 'total_friend_count', fromJson: ConvertData.stringToInt)
  int? friendCount;

  @JsonKey(name: 'xprofile', fromJson: _fromProfile, toJson: _toProfile)
  List<BPMemberProfile>? profile;

  @JsonKey(name: 'friendship_status')
  bool? friendshipStatus;

  @JsonKey(name: 'friendship_status_slug', fromJson: _fromFriendshipSlug)
  String? friendshipStatusSlug;

  BPMember({
    this.id,
    this.name,
    this.userLogin,
    this.mentionName,
    this.avatar,
    this.registeredSince,
    this.lastActive,
    this.friendshipStatus,
    this.friendshipStatusSlug,
    this.friendCount,
    this.profile,
  });

  factory BPMember.fromJson(Map<String, dynamic> json) => _$BPMemberFromJson(json);
  Map<String, dynamic> toJson() => _$BPMemberToJson(this);

  static String? _fromAvatarUrls(dynamic value) {
    String text = get(value, ["full"], "");
    return text.contains("http")
        ? text
        : text.isNotEmpty
        ? "https:$text"
        : null;
  }

  static List<BPMemberProfile>? _fromProfile(dynamic value) {
    if (value is Map && value['groups'] is List && value['groups'].isNotEmpty) {
      return value['groups'].map((e) => BPMemberProfile.fromJson(e)).toList().cast<BPMemberProfile>();
    }
    return null;
  }

  static String? _fromLastActive(dynamic value) {
    if (value is Map && value['timediff'] is String) {
      return value['timediff'];
    }
    return null;
  }

  static String? _fromFriendshipSlug(dynamic value) {
    if (value is String) {
      return value;
    }
    return null;
  }

  static dynamic _toAvatarUrls(String? value) {
    return {
      "full": value
    };
  }

  static dynamic _toLastActive(String? value) {
    return {
      "timediff": value
    };
  }

  static dynamic _toProfile(List<BPMemberProfile>? value) {
    List? data;
    if (value?.isNotEmpty == true) {
      data = value!.map((e) => e.toJson()).toList();
    }
    return {
      "groups": data
    };
  }
}

@JsonSerializable()
class BPMemberProfile {
  int? id;

  String? name;

  @JsonKey(fromJson: _fromField, toJson: _toField)
  List<BPMemberProfileField>? fields;

  BPMemberProfile({
    this.id,
    this.name,
    this.fields,
  });

  factory BPMemberProfile.fromJson(Map<String, dynamic> json) => _$BPMemberProfileFromJson(json);
  Map<String, dynamic> toJson() => _$BPMemberProfileToJson(this);

  static List<BPMemberProfileField>? _fromField(dynamic value) {
    if (value is List && value.isNotEmpty) {
      return value.map((e) => BPMemberProfileField.fromJson(e)).toList().cast<BPMemberProfileField>();
    }

    if (value is Map && value.isNotEmpty) {
      return value.values.map((e) => BPMemberProfileField.fromJson(e)).toList().cast<BPMemberProfileField>();
    }
    return null;
  }

  static dynamic _toField(List<BPMemberProfileField>? value) {
    if (value?.isNotEmpty == true) {
      return value!.map((e) => e.toJson()).toList();
    }
    return null;
  }
}

@JsonSerializable()
class BPMemberProfileField {
  int? id;

  String? name;

  @JsonKey(fromJson: _fromValue, toJson: _toValue)
  String? value;

  BPMemberProfileField({
    this.id,
    this.name,
    this.value,
  });

  factory BPMemberProfileField.fromJson(Map<String, dynamic> json) => _$BPMemberProfileFieldFromJson(json);
  Map<String, dynamic> toJson() => _$BPMemberProfileFieldToJson(this);

  static String? _fromValue(dynamic value) {
    if (value is Map && value["rendered"] is String) {
      return value["rendered"];
    }
    return null;
  }

  static dynamic _toValue(String? value) {
    if (value?.isNotEmpty == true) {
      return {
        "rendered": value
      };
    }
    return null;
  }
}