import 'dart:ffi';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:smartrecycler/UserPage/User.dart';

part 'UserRepository.g.dart';


@RestApi(baseUrl: 'http://203.249.77.25:8080/v1/')

abstract class UserRepository {
  factory UserRepository(Dio dio, {String? baseUrl}) =
  _UserRepository;

  @POST('user')
  Future<String> createUser(@Body()User user);

  @DELETE('user/{userId}')
  Future<void> deleteUser(@Path('userId')Long userId);

  @GET('user/login/{email}/{password}')
  Future login(@Path('email') String email, @Path('password') String password );

  @GET('user/password/{email}/{profileName}')
  Future getPassword(@Path('email') String email, @Path('profileName') String profileName );

  @GET('user/duplicate/email/{email}')
  Future checkDuplicateLoginId(@Path('email') String email );

  @PUT('user/{userId}/password/{originPwd}/{newPwd}')
  Future updatePassword(@Path('userId') Long userId, @Path('originPwd') String originPwd, @Path('newPwd') String newPwd);

}