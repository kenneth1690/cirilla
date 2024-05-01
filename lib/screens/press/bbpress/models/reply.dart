import 'package:json_annotation/json_annotation.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

part 'reply.g.dart';

@JsonSerializable(createToJson: false)
class BBPReply {
  int? id;

  String? title;

  String? content;

  @JsonKey(name: "reply_to")
  int? parent;

  @JsonKey(name: 'author_name')
  String? authorName;

  @JsonKey(name: 'author_avatar', fromJson: _fromAvatar)
  String? authorAvatar;

  @JsonKey(name: 'post_date')
  String? date;

  BBPReply({
    this.id,
    this.title,
    this.content,
    this.parent,
    this.authorName,
    this.authorAvatar,
    this.date,
  });

  factory BBPReply.fromJson(Map<String, dynamic> json) => _$BBPReplyFromJson(json);

  static String? _fromAvatar(dynamic value) {
    if (value is String && value.isNotEmpty) {
      var document = parse(value);
      dom.Element? link = document.querySelector('img');
      String? imageLink = link?.attributes['src'];
      return imageLink?.isNotEmpty == true ? imageLink!.contains("https:") ? imageLink : "https:$imageLink": imageLink;
    }
    return null;
  }
}
