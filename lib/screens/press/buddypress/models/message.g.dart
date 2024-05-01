// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BPMessage _$BPMessageFromJson(Map<String, dynamic> json) => BPMessage(
      id: json['id'] as int?,
      senderId: json['sender_id'] as int?,
      title: BPMessage._fromText(json['subject']),
      message: BPMessage._fromText(json['message']),
      date: convertToDate(json['date_sent']),
    );
