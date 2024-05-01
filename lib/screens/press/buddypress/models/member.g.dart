// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BPMember _$BPMemberFromJson(Map<String, dynamic> json) => BPMember(
      id: json['id'] as int?,
      name: json['name'] as String?,
      userLogin: json['user_login'] as String?,
      mentionName: json['mention_name'] as String?,
      avatar: BPMember._fromAvatarUrls(json['avatar_urls']),
      registeredSince: json['registered_since'] as String?,
      lastActive: BPMember._fromLastActive(json['last_activity']),
      friendshipStatus: json['friendship_status'] as bool?,
      friendshipStatusSlug:
          BPMember._fromFriendshipSlug(json['friendship_status_slug']),
      friendCount: ConvertData.stringToInt(json['total_friend_count']),
      profile: BPMember._fromProfile(json['xprofile']),
    );

Map<String, dynamic> _$BPMemberToJson(BPMember instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'user_login': instance.userLogin,
      'mention_name': instance.mentionName,
      'avatar_urls': BPMember._toAvatarUrls(instance.avatar),
      'registered_since': instance.registeredSince,
      'last_activity': BPMember._toLastActive(instance.lastActive),
      'total_friend_count': instance.friendCount,
      'xprofile': BPMember._toProfile(instance.profile),
      'friendship_status': instance.friendshipStatus,
      'friendship_status_slug': instance.friendshipStatusSlug,
    };

BPMemberProfile _$BPMemberProfileFromJson(Map<String, dynamic> json) =>
    BPMemberProfile(
      id: json['id'] as int?,
      name: json['name'] as String?,
      fields: BPMemberProfile._fromField(json['fields']),
    );

Map<String, dynamic> _$BPMemberProfileToJson(BPMemberProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fields': BPMemberProfile._toField(instance.fields),
    };

BPMemberProfileField _$BPMemberProfileFieldFromJson(
        Map<String, dynamic> json) =>
    BPMemberProfileField(
      id: json['id'] as int?,
      name: json['name'] as String?,
      value: BPMemberProfileField._fromValue(json['value']),
    );

Map<String, dynamic> _$BPMemberProfileFieldToJson(
        BPMemberProfileField instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'value': BPMemberProfileField._toValue(instance.value),
    };
