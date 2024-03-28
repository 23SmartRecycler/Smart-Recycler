// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
      cid: json['cid'] as int?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      slink: json['slink'] as String?,
    );

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'cid': instance.cid,
      'title': instance.title,
      'content': instance.content,
      'slink': instance.slink,
    };
