import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:smartrecycler/UserPage/userRetrofit/User.dart';
import 'package:smartrecycler/common/TaskServer.dart';

part 'UserRepository.g.dart';


@RestApi(baseUrl: serverUrl)

abstract class UserRepository {
  factory UserRepository(Dio dio, {String? baseUrl}) =
  _UserRepository;

  @POST('user')
  Future<String> createUser(@Body()User user);

  @DELETE('user/{uid}')
  Future<void> deleteUser(@Path('uid')int uid);

  @GET('user/{uid}')
  Future<User> getUser(@Path('uid') int uid);

  @GET('user/login/{email}/{password}')
  Future login(@Path('email') String email, @Path('password') String password );

  @GET('user/password/{email}/{profileName}')
  Future getPassword(@Path('email') String email, @Path('profileName') String profileName );

  @GET('user/duplicate/email/{email}')
  Future checkDuplicateLoginId(@Path('email') String email );

  @PUT('user/{userId}/password/{originPwd}/{newPwd}')
  Future updatePassword(@Path('uid') int uid, @Path('originPwd') String originPwd, @Path('newPwd') String newPwd);

  @PUT('user/{uid}/exchange/{price}')
  Future updatePoint(@Path('uid') int uid, @Path('price') int price);
}