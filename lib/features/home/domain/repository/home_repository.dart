import 'package:dartz/dartz.dart';
import 'package:grabber/core/network/exceptions.dart';

import '../../data/models/response/get_video_info_model.dart';

abstract interface class HomeRepository {
  Future<Either<ServerException, GetVideoInfoModel>> getVideoInfo(String url);
}
