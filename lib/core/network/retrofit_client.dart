import 'package:dio/dio.dart';
import 'package:grabber/core/network/end_points.dart';
import 'package:grabber/features/home/data/models/response/get_video_info_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'retrofit_client.g.dart';

@singleton
@injectable
@RestApi(baseUrl: EndPoints.baseUrl)
abstract class RetrofitClient {
  @factoryMethod
  factory RetrofitClient(Dio dio) => _$RetrofitClient;

  @POST(EndPoints.getInfo)
  Future<GetVideoInfoModel> getVideoInfo(@Body() String url);
}
