import 'dart:ffi';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:smartrecycler/UserPage/User.dart';

part 'UserRepository.g.dart';

@RestApi(baseUrl: 'http://localhost:8080//v1/')
abstract class UserRepository {
  factory UserRepository(Dio dio, {String? baseUrl}) =
  _UserRepository;

  @POST('user')
  Future<String> createUser(@Body()User user);

  @DELETE('user/{userId}')
  Future<void> deleteUser(@Path('userId')Long userId);

  @GET('user/login/{email}/{password}')
  Future<List<Long>> login(@Path('email') String email, @Path('password') String password );

  @GET('user/login/{email}/{profileName}')
  Future<List<Bool>> getPassword(@Path('email') String email, @Path('profileName') String profileName );

  @GET('user/duplicate/email/{email}')
  Future<List<Bool>> checkDuplicateLoginId(@Path('email') String email );

  @PUT('user/{userId}/password/{originPwd}/{newPwd}')
  Future<List<Bool>> updatePassword(@Path('userId') Long userId, @Path('originPwd') String originPwd, @Path('newPwd') String newPwd);

}