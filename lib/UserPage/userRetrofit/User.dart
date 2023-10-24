import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()
class User {
  final String? email;
  final String? password;
  final String? profileName;
  final int? point;
  final int? exp;
  final String? profileImage;

  User({required this.email, required this.password, required this.profileName, required this.point, required this.exp,required this.profileImage});

  factory User.fromJson(Map<String, dynamic> json) =>_$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}