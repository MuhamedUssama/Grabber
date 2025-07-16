import 'package:dio/dio.dart';
import 'package:grabber/core/network/end_points.dart';
import 'package:grabber/features/home/data/models/request/download_audio_request_model.dart';
import 'package:grabber/features/home/data/models/request/download_video_request_model.dart';
import 'package:grabber/features/home/data/models/request/get_video_info_request.dart';
import 'package:grabber/features/home/data/models/response/download_audio_response_model.dart';
import 'package:grabber/features/home/data/models/response/download_video_response_model.dart';
import 'package:grabber/features/home/data/models/response/get_video_info_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'retrofit_client.g.dart';

@singleton
@RestApi(baseUrl: EndPoints.baseUrl)
abstract class RetrofitClient {
  @factoryMethod
  factory RetrofitClient(Dio dio) = _RetrofitClient;

  @POST(EndPoints.getInfo)
  Future<GetVideoInfoModel> getVideoInfo(@Body() GetVideoInfoRequest request);

  @POST(EndPoints.downloadAudio)
  Future<DownloadAudioResponseModel> downloadAudio(
    @Body() DownloadAudioRequestModel request,
  );

  @POST(EndPoints.downloadVideoWithoutAudio)
  Future<DownloadVideoResponseModel> downloadVideoWithoutAudio(
    @Body() DownloadVideoRequestModel request,
  );

  @POST(EndPoints.downloadVideo)
  Future<DownloadVideoResponseModel> downloadVideo(
    @Body() DownloadVideoRequestModel request,
  );
}
