import 'package:dio/dio.dart';
import 'package:grabber/core/network/end_points.dart';
import 'package:grabber/features/home/data/models/request/download_audio_request_model.dart';
import 'package:grabber/features/home/data/models/request/download_subtitle_request_model.dart';
import 'package:grabber/features/home/data/models/request/download_video_request_model.dart';
import 'package:grabber/features/home/data/models/request/get_video_info_request.dart';
import 'package:grabber/features/home/data/models/response/download_audio_response_model.dart';
import 'package:grabber/features/home/data/models/response/download_status_response_model.dart';
import 'package:grabber/features/home/data/models/response/download_subtitle_response_model.dart';
import 'package:grabber/features/home/data/models/response/download_video_response_model.dart';
import 'package:grabber/features/home/data/models/response/get_info_response_model.dart'
    hide Options;
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
  Future<GetInfoResponseModel> getInfo(@Body() GetVideoInfoRequest request);

  @POST(EndPoints.downloadAudio)
  Future<DownloadAudioResponseModel> downloadAudio(
    @Body() DownloadAudioRequestModel request,
  );

  @POST(EndPoints.downloadVideo)
  Future<DownloadVideoResponseModel> downloadVideo(
    @Body() DownloadVideoRequestModel request,
  );

  @POST(EndPoints.downloadSubtitle)
  Future<DownloadSubtitleResponseModel> downloadSubtitle(
    @Body() DownloadSubtitleRequestModel request,
  );

  @GET(EndPoints.getTaskStatus)
  Future<DownloadStatusResponseModel> getTaskStatus(
    @Path("taskId") String taskId,
  );

  @POST(EndPoints.cancelTask)
  Future<void> cancelTask(@Path("taskId") String taskId);
}
