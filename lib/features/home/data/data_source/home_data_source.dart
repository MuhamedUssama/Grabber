import 'package:dartz/dartz.dart';
import 'package:grabber/core/network/exceptions.dart';
import 'package:grabber/features/home/data/models/request/download_audio_request_model.dart';
import 'package:grabber/features/home/data/models/request/download_subtitle_request_model.dart';
import 'package:grabber/features/home/data/models/request/download_video_request_model.dart';
import 'package:grabber/features/home/data/models/request/get_video_info_request.dart';
import 'package:grabber/features/home/data/models/response/download_audio_response_model.dart';
import 'package:grabber/features/home/data/models/response/download_status_response_model.dart';
import 'package:grabber/features/home/data/models/response/download_subtitle_response_model.dart';
import 'package:grabber/features/home/data/models/response/download_video_response_model.dart';
import 'package:grabber/features/home/data/models/response/get_info_response_model.dart';

abstract interface class HomeDataSource {
  Future<Either<ServerException, GetInfoResponseModel>> getVideoInfo(
    GetVideoInfoRequest request,
  );

  Future<Either<ServerException, DownloadAudioResponseModel>> downloadAudio(
    DownloadAudioRequestModel request,
  );

  Future<Either<ServerException, DownloadVideoResponseModel>> downloadVideo(
    DownloadVideoRequestModel request,
  );

  Future<Either<ServerException, DownloadSubtitleResponseModel>>
  downloadSubtitle(DownloadSubtitleRequestModel request);

  Future<Either<ServerException, DownloadStatusResponseModel>> getTaskStatus(
    String taskId,
  );

  Future<Either<ServerException, void>> cancelTask(String taskId);
}
