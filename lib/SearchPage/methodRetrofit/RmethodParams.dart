import 'package:json_annotation/json_annotation.dart';

part 'RmethodParams.g.dart';

@JsonSerializable()
class RmethodParams {
  final int? mid;
  final String? title;
  final String? img;



  RmethodParams({required this.mid,required this.title,required this.img});

  factory RmethodParams.fromJson(Map<String, dynamic> json) =>
      _$RmethodParamsFromJson(json);

  Map<String, dynamic> toJson() => _$RmethodParamsToJson(this);

}