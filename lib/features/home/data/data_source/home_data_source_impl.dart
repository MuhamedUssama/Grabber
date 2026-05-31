import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:grabber/core/network/exceptions.dart';
import 'package:grabber/core/network/retrofit_client.dart';
import 'package:grabber/features/home/data/data_source/home_data_source.dart';
import 'package:grabber/features/home/data/models/request/download_audio_request_model.dart';
import 'package:grabber/features/home/data/models/request/download_subtitle_request_model.dart';
import 'package:grabber/features/home/data/models/request/download_video_request_model.dart';
import 'package:grabber/features/home/data/models/request/get_video_info_request.dart';
import 'package:grabber/features/home/data/models/response/download_audio_response_model.dart';
import 'package:grabber/features/home/data/models/response/download_status_response_model.dart';
import 'package:grabber/features/home/data/models/response/download_subtitle_response_model.dart';
import 'package:grabber/features/home/data/models/response/download_video_response_model.dart';
import 'package:grabber/features/home/data/models/response/get_info_response_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeDataSource)
class HomeDataSourceImpl implements HomeDataSource {
  final RetrofitClient _retrofitClient;
  const HomeDataSourceImpl(this._retrofitClient);

  @override
  Future<Either<ServerException, GetInfoResponseModel>> getVideoInfo(
    GetVideoInfoRequest request,
  ) async {
    try {
      final response = await _retrofitClient.getInfo(request);
      return Right(response);
    } on DioException catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<ServerException, DownloadAudioResponseModel>> downloadAudio(
    DownloadAudioRequestModel request,
  ) async {
    try {
      final response = await _retrofitClient.downloadAudio(request);
      return Right(response);
    } on DioException catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<ServerException, DownloadVideoResponseModel>> downloadVideo(
    DownloadVideoRequestModel request,
  ) async {
    try {
      final response = await _retrofitClient.downloadVideo(request);
      return Right(response);
    } on DioException catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<ServerException, DownloadSubtitleResponseModel>>
  downloadSubtitle(DownloadSubtitleRequestModel request) async {
    try {
      final response = await _retrofitClient.downloadSubtitle(request);
      return Right(response);
    } on DioException catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<ServerException, DownloadStatusResponseModel>> getTaskStatus(
    String taskId,
  ) async {
    try {
      final response = await _retrofitClient.getTaskStatus(taskId);
      return Right(response);
    } on DioException catch (exception) {
      return Left(_handleException(exception));
    }
  }

  @override
  Future<Either<ServerException, void>> cancelTask(String taskId) async {
    try {
      await _retrofitClient.cancelTask(taskId);
      return const Right(null);
    } on DioException catch (exception) {
      return Left(_handleException(exception));
    }
  }

  ServerException _handleException(DioException exception) {
    if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.sendTimeout) {
      return const NoInternetConnectionException();
    } else if (exception.response != null) {
      return _handleStatusCode(exception.response!.statusCode);
    } else {
      log('exception: $exception');
      return const FetchDataException();
    }
  }

  ServerException _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return const BadRequestException();
      case 401:
        return const UnauthorizedException();
      case 404:
        return const NotFoundException();
      case 409:
        return const ConflictException();
      case 500:
        return const InternalServerErrorException();
      default:
        return const FetchDataException();
    }
  }
}
