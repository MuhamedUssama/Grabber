import 'package:dartz/dartz.dart';
import 'package:grabber/core/network/exceptions.dart';
import 'package:grabber/core/utils/connectivity_helper.dart';
import 'package:grabber/features/home/data/models/request/download_audio_request_model.dart';
import 'package:grabber/features/home/data/models/request/download_video_request_model.dart';
import 'package:grabber/features/home/data/models/request/get_video_info_request.dart';
import 'package:grabber/features/home/data/models/response/download_audio_response_model.dart';
import 'package:grabber/features/home/data/models/response/download_video_response_model.dart';
import 'package:grabber/features/home/data/models/response/get_video_info_model.dart';
import 'package:grabber/features/home/domain/repository/home_repository.dart';
import 'package:injectable/injectable.dart';

import '../data_source/home_data_source.dart';

@Injectable(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource _dataSource;

  HomeRepositoryImpl(this._dataSource);

  @override
  Future<Either<ServerException, GetVideoInfoModel>> getVideoInfo(
    GetVideoInfoRequest url,
  ) async {
    if (await ConnectivityHelper.checkInternetConnection()) {
      final either = await _dataSource.getVideoInfo(url);

      return either.fold(
        (error) => Left(ServerException(error.message)),
        (videoInfo) => Right(videoInfo),
      );
    } else {
      return Left(NoInternetConnectionException());
    }
  }

  @override
  Future<Either<ServerException, DownloadAudioResponseModel>> downloadAudio(
    DownloadAudioRequestModel request,
  ) async {
    if (await ConnectivityHelper.checkInternetConnection()) {
      final either = await _dataSource.downloadAudio(request);

      return either.fold(
        (error) => Left(ServerException(error.message)),
        (filePath) => Right(filePath),
      );
    } else {
      return Left(NoInternetConnectionException());
    }
  }

  @override
  Future<Either<ServerException, DownloadVideoResponseModel>> downloadVideo(
    DownloadVideoRequestModel request,
  ) async {
    if (await ConnectivityHelper.checkInternetConnection()) {
      final either = await _dataSource.downloadVideo(request);

      return either.fold(
        (error) => Left(ServerException(error.message)),
        (filePath) => Right(filePath),
      );
    } else {
      return Left(NoInternetConnectionException());
    }
  }

  @override
  Future<Either<ServerException, DownloadVideoResponseModel>>
  downloadVideoWithoutAudio(DownloadVideoRequestModel request) async {
    if (await ConnectivityHelper.checkInternetConnection()) {
      final either = await _dataSource.downloadVideoWithoutAudio(request);

      return either.fold(
        (error) => Left(ServerException(error.message)),
        (filePath) => Right(filePath),
      );
    } else {
      return Left(NoInternetConnectionException());
    }
  }
}
