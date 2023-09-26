import 'package:json_annotation/json_annotation.dart';

part 'Gifticon.g.dart';

@JsonSerializable()
class Gifticon {
  final String? gName;
  final int? price;
  final int? stockQuantitiy;
  final String? expireData;

  Gifticon({
    required this.gName,
    required this.price,
    required this.stockQuantitiy,
    required this.expireData,
  });

  factory Gifticon.fromJson(Map<String, dynamic> json) => _$GifticonFromJson(json);

  Map<String, dynamic> toJson() => _$GifticonToJson(this);
}
