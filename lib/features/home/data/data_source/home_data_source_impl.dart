import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:grabber/core/network/exceptions.dart';
import 'package:grabber/core/network/retrofit_client.dart';
import 'package:grabber/features/home/data/data_source/home_data_source.dart';
import 'package:grabber/features/home/data/models/request/get_video_info_request.dart';
import 'package:grabber/features/home/data/models/response/get_video_info_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeDataSource)
class HomeDataSourceImpl implements HomeDataSource {
  final RetrofitClient _retrofitClient;

  HomeDataSourceImpl(this._retrofitClient);

  @override
  Future<Either<ServerException, GetVideoInfoModel>> getVideoInfo(
    GetVideoInfoRequest url,
  ) async {
    try {
      GetVideoInfoModel response = await _retrofitClient.getVideoInfo(url);
      return Right(response);
    } on DioException catch (exception) {
      if (exception.type == DioExceptionType.connectionTimeout ||
          exception.type == DioExceptionType.receiveTimeout ||
          exception.type == DioExceptionType.sendTimeout) {
        return const Left(NoInternetConnectionException());
      } else if (exception.response != null) {
        return Left(_handleStatusCode(exception.response!.statusCode));
      } else {
        log('exception: $exception');
        return const Left(FetchDataException());
      }
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
