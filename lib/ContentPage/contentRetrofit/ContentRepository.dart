import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:smartrecycler/ContentPage/contentRetrofit/Content.dart';
import 'package:smartrecycler/common/TaskServer.dart';

part 'ContentRepository.g.dart';


@RestApi(baseUrl: serverUrl)

abstract class ContentRepository {
  factory ContentRepository(Dio dio, {String? baseUrl}) =
  _ContentRepository;

  @POST('content')
  Future<String> createContent(@Body()Content content);

  @DELETE('content/{cid}')
  Future<void> deleteContent(@Path('cid')int cid);

  @GET('contents/')
  Future<List<Content>> getContents();

  @GET('content/{cid}')
  Future<Content> getContent(@Path('cid')int cid);
}