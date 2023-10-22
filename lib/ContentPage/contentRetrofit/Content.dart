import 'package:json_annotation/json_annotation.dart';

part 'Content.g.dart';

@JsonSerializable()
class Content {
  final String? title;
  final String? content;

  Content({required this.title, required this.content});

  factory Content.fromJson(Map<String, dynamic> json) =>_$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);

}