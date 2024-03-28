import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:smartrecycler/SearchPage/methodRetrofit/Rmethod.dart';
import 'package:smartrecycler/SearchPage/methodRetrofit/RmethodParams.dart';
import 'package:smartrecycler/common/TaskServer.dart';

part 'RmethodRepository.g.dart';


@RestApi(baseUrl: serverUrl)

abstract class RmethodRepository {
  factory RmethodRepository(Dio dio, {String? baseUrl}) =
  _RmethodRepository;

  @POST('method')
  Future<String> createRmethod(@Body()Method method);

  @DELETE('method/{mid}')
  Future<void> deleteRmethod(@Path('mid')int mid);

  @GET('methods/')
  Future<List<RmethodParams>> getRmethods();

  @GET('method/{mid}')
  Future<Rmethod> getRmethod(@Path('mid')int mid);

}