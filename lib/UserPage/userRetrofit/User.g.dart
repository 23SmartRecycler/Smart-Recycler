// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      email: json['email'] as String?,
      password: json['password'] as String?,
      profileName: json['profileName'] as String?,
      point: json['point'] as int?,
      exp: json['exp'] as int?,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'profileName': instance.profileName,
      'point': instance.point,
      'exp': instance.exp,
      'profileImage': instance.profileImage,
    };
