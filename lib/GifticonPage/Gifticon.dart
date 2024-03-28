import 'package:json_annotation/json_annotation.dart';

part 'Gifticon.g.dart';

@JsonSerializable()
class GifticonList{
  List<GifticonItem>? list;

  GifticonList({required this.list,});

  //fromJson(json) : json파일을 매개변수로 받아서 gifticonList를 만드는 함수
  factory GifticonList.fromJson(Map<String, dynamic> json) =>
      _$GifticonListFromJson(json);

  //toJson() : GifticonList(자신)를 매개변수로 json파일을 만드는 함수
  Map<String, dynamic> toJson() => _$GifticonListToJson(this);
}

@JsonSerializable()
class GifticonItem {
  final int? gid;
  final String? gimage;
  final String? gname;
  final String? uid;
  final int? price;
  final int? stockQuantity;
  final String? expireData;

  GifticonItem({
    required this.gid,
    required this.gimage,
    required this.gname,
    required this.uid,
    required this.price,
    required this.stockQuantity,
    required this.expireData,
  });

  factory GifticonItem.fromJson(Map<String, dynamic> json) => _$GifticonItemFromJson(json);

  Map<String, dynamic> toJson() => _$GifticonItemToJson(this);
}
