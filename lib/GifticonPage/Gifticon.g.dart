// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Gifticon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gifticon _$GifticonFromJson(Map<String, dynamic> json) => Gifticon(
      gName: json['gName'] as String?,
      price: json['price'] as int?,
      stockQuantitiy: json['stockQuantitiy'] as int?,
      expireData: json['expireData'] as String?,
    );

Map<String, dynamic> _$GifticonToJson(Gifticon instance) => <String, dynamic>{
      'gName': instance.gName,
      'price': instance.price,
      'stockQuantitiy': instance.stockQuantitiy,
      'expireData': instance.expireData,
    };
