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
      gid: json['gid'] as int?,
      gimage: json['gimage'] as String?,
      gname: json['gname'] as String?,
      uid: json['uid'] as String?,
      price: json['price'] as int?,
      stockQuantity: json['stockQuantity'] as int?,
      expireData: json['expireData'] as String?,
    );

Map<String, dynamic> _$GifticonItemToJson(GifticonItem instance) =>
    <String, dynamic>{
      'gid': instance.gid,
      'gimage': instance.gimage,
      'gname': instance.gname,
      'uid': instance.uid,
      'price': instance.price,
      'stockQuantity': instance.stockQuantity,
      'expireData': instance.expireData,
    };
