import 'package:dartz/dartz.dart';
import 'package:grabber/core/network/exceptions.dart';
import 'package:grabber/features/home/data/models/request/get_video_info_request.dart';

import '../../data/models/response/get_video_info_model.dart';

abstract interface class HomeRepository {
  Future<Either<ServerException, GetVideoInfoModel>> getVideoInfo(
    GetVideoInfoRequest url,
  );
}
