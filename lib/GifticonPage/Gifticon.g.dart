// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Gifticon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GifticonList _$GifticonListFromJson(Map<String, dynamic> json) => GifticonList(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => GifticonItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GifticonListToJson(GifticonList instance) =>
    <String, dynamic>{
      'list': instance.list,
    };

GifticonItem _$GifticonItemFromJson(Map<String, dynamic> json) => GifticonItem(
      gImage: json['gImage'] as String?,
      gName: json['gName'] as String?,
      price: json['price'] as int?,
      stockQuantitiy: json['stockQuantitiy'] as int?,
      expireData: json['expireData'] as String?,
    );

Map<String, dynamic> _$GifticonItemToJson(GifticonItem instance) =>
    <String, dynamic>{
      'gImage': instance.gImage,
      'gName': instance.gName,
      'price': instance.price,
      'stockQuantitiy': instance.stockQuantitiy,
      'expireData': instance.expireData,
    };
