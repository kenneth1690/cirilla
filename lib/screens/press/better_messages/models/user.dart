import 'package:cirilla/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(createToJson: false)
class BMUser {

  @JsonKey(fromJson: ConvertData.stringToInt)
  int? id;

  @JsonKey(name: "user_id")
  int? userId;

  String? name;

  String? avatar;


  BMUser({
    this.id,
    this.userId,
    this.name,
    this.avatar,
  });


  factory BMUser.fromJson(Map<String, dynamic> json) => _$BMUserFromJson(json);
}