import 'package:dartz/dartz.dart';
import 'package:grabber/core/network/exceptions.dart';
import 'package:grabber/features/home/data/models/request/download_audio_request_model.dart';
import 'package:grabber/features/home/data/models/request/download_video_request_model.dart';
import 'package:grabber/features/home/data/models/request/get_video_info_request.dart';
import 'package:grabber/features/home/data/models/response/download_audio_response_model.dart';
import 'package:grabber/features/home/data/models/response/download_video_response_model.dart';

import '../../data/models/response/get_video_info_model.dart';

abstract interface class HomeRepository {
  Future<Either<ServerException, GetVideoInfoModel>> getVideoInfo(
    GetVideoInfoRequest url,
  );

  Future<Either<ServerException, DownloadAudioResponseModel>> downloadAudio(
    DownloadAudioRequestModel request,
  );

  Future<Either<ServerException, DownloadVideoResponseModel>>
  downloadVideoWithoutAudio(DownloadVideoRequestModel request);

  Future<Either<ServerException, DownloadVideoResponseModel>> downloadVideo(
    DownloadVideoRequestModel request,
  );
}
