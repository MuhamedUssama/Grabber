import 'package:dartz/dartz.dart';
import 'package:grabber/core/network/exceptions.dart';
import 'package:grabber/features/home/domain/repository/home_repository.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/response/get_video_info_model.dart';

@injectable
class GetVideoInfoUsecase {
  final HomeRepository _repository;

  GetVideoInfoUsecase(this._repository);

  Future<Either<ServerException, GetVideoInfoModel>> call(String url) async =>
      _repository.getVideoInfo(url);
}
