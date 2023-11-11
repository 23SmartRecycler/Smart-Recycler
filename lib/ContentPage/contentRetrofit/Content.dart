import 'package:json_annotation/json_annotation.dart';

part 'Content.g.dart';

@JsonSerializable()
class Content {
  final int? cid;
  final String? title;
  final String? content;
  final String? slink;

  Content({required this.cid,required this.title, required this.content,required this.slink});

  factory Content.fromJson(Map<String, dynamic> json) =>_$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);

}