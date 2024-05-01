// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BMUser _$BMUserFromJson(Map<String, dynamic> json) => BMUser(
      id: ConvertData.stringToInt(json['id']),
      userId: json['user_id'] as int?,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
    );
