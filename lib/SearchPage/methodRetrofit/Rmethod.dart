import 'package:json_annotation/json_annotation.dart';

part 'Rmethod.g.dart';

@JsonSerializable()
class Rmethod {
  final String? title;
  final String? method;
  final String? img;


  Rmethod({required this.title, required this.method,required this.img});

  factory Rmethod.fromJson(Map<String, dynamic> json) =>
      _$RmethodFromJson(json);

  Map<String, dynamic> toJson() => _$RmethodToJson(this);

}