import 'dart:ffi';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:smartrecycler/GifticonPage/Gifticon.dart';

part 'GifticonRepository.g.dart';

@RestApi(baseUrl: 'http://localhost:8080//v1/')
abstract class GifticonRepository{
  factory GifticonRepository(Dio dio, {String? baseUrl}) = _GifticonRepository;

  @POST('gifticons/new')
  Future<String> createGifticon(@Body()GifticonItem gifticon);

  @GET('/gifticons')
  Future<List<GifticonItem>> list();
}