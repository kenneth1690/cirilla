// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BPMemberGroup _$BPMemberGroupFromJson(Map<String, dynamic> json) =>
    BPMemberGroup(
      id: json['id'] as int?,
      name: json['name'] as String?,
      userLogin: json['user_login'] as String?,
      mentionName: json['mention_name'] as String?,
      avatar: BPMemberGroup._fromAvatarUrls(json['avatar_urls']),
      isMod: json['is_mod'] as bool?,
      isAdmin: json['is_admin'] as bool?,
      isBanned: json['is_banned'] as bool?,
      isConfirmed: json['is_confirmed'] as bool?,
      date: convertToDate(json['date_modified_gmt']),
    );
