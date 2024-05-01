import 'package:cirilla/mixins/utility_mixin.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../utils.dart';

part 'message.g.dart';

@JsonSerializable(createToJson: false)
class BPMessage {
  int? id;

  @JsonKey(name: 'sender_id')
  int? senderId;

  @JsonKey(name: 'subject', fromJson: _fromText)
  String? title;

  @JsonKey(name: 'message', fromJson: _fromText)
  String? message;

  @JsonKey(name: 'date_sent', fromJson: convertToDate)
  DateTime? date;

  BPMessage({
    this.id,
    this.senderId,
    this.title,
    this.message,
    this.date,
  });

  factory BPMessage.fromJson(Map<String, dynamic> json) => _$BPMessageFromJson(json);

  static String? _fromText(dynamic value) {
    return get(value, ["rendered"]) as String?;
  }
}
