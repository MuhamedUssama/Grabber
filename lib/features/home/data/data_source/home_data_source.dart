import 'package:dartz/dartz.dart';
import 'package:grabber/core/network/exceptions.dart';
import 'package:grabber/features/home/data/models/response/get_video_info_model.dart';

abstract interface class HomeDataSource {
  Future<Either<ServerException, GetVideoInfoModel>> getVideoInfo(String url);
}
