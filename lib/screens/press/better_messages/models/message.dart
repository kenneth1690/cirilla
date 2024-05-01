import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable(createToJson: false)
class BMMessage {

  @JsonKey(name: "message_id")
  int? id;

  @JsonKey(name: "thread_id")
  int? threadId;

  @JsonKey(name: "sender_id")
  int? senderId;

  String? message;

  @JsonKey(name: "date_sent")
  String? date;


  BMMessage({
    this.id,
    this.threadId,
    this.senderId,
    this.message,
    this.date,
  });

  factory BMMessage.fromJson(Map<String, dynamic> json) => _$BMMessageFromJson(json);
}