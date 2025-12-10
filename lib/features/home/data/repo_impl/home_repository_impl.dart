import 'package:dartz/dartz.dart';
import 'package:grabber/core/network/exceptions.dart';
import 'package:grabber/core/utils/connectivity_helper.dart';
import 'package:grabber/features/home/data/data_source/home_data_source.dart';
import 'package:grabber/features/home/data/models/request/download_audio_request_model.dart';
import 'package:grabber/features/home/data/models/request/download_subtitle_request_model.dart';
import 'package:grabber/features/home/data/models/request/download_video_request_model.dart';
import 'package:grabber/features/home/data/models/request/get_video_info_request.dart';
import 'package:grabber/features/home/data/models/response/download_status_response_model.dart';
import 'package:grabber/features/home/data/models/response/get_info_response_model.dart';
import 'package:grabber/features/home/domain/repository/home_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource _dataSource;

  HomeRepositoryImpl(this._dataSource);

  @override
  Future<Either<ServerException, GetInfoResponseModel>> getVideoInfo(
    GetVideoInfoRequest request,
  ) async {
    if (await ConnectivityHelper.checkInternetConnection()) {
      return await _dataSource.getVideoInfo(request);
    } else {
      return const Left(NoInternetConnectionException());
    }
  }

  @override
  Future<Either<ServerException, String>> downloadAudio(
    DownloadAudioRequestModel request,
  ) async {
    if (await ConnectivityHelper.checkInternetConnection()) {
      final result = await _dataSource.downloadAudio(request);
      return result.map((response) => response.data.taskId);
    } else {
      return const Left(NoInternetConnectionException());
    }
  }

  @override
  Future<Either<ServerException, String>> downloadVideo(
    DownloadVideoRequestModel request,
  ) async {
    if (await ConnectivityHelper.checkInternetConnection()) {
      final result = await _dataSource.downloadVideo(request);
      return result.map((response) => response.data.taskId);
    } else {
      return const Left(NoInternetConnectionException());
    }
  }

  @override
  Future<Either<ServerException, String>> downloadSubtitle(
    DownloadSubtitleRequestModel request,
  ) async {
    if (await ConnectivityHelper.checkInternetConnection()) {
      final result = await _dataSource.downloadSubtitle(request);
      return result.map((response) => response.data.taskId);
    } else {
      return const Left(NoInternetConnectionException());
    }
  }

  @override
  Future<Either<ServerException, DownloadStatusResponseModel>> getTaskStatus(
    String taskId,
  ) async {
    if (await ConnectivityHelper.checkInternetConnection()) {
      return await _dataSource.getTaskStatus(taskId);
    } else {
      return const Left(NoInternetConnectionException());
    }
  }

  @override
  Future<Either<ServerException, void>> cancelTask(String taskId) async {
    if (await ConnectivityHelper.checkInternetConnection()) {
      return await _dataSource.cancelTask(taskId);
    } else {
      return const Left(NoInternetConnectionException());
    }
  }
}
