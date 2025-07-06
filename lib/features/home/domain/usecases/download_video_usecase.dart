import 'package:dartz/dartz.dart';
import 'package:grabber/core/network/exceptions.dart';
import 'package:grabber/features/home/data/models/request/download_video_request_model.dart';
import 'package:grabber/features/home/data/models/response/download_video_response_model.dart';
import 'package:grabber/features/home/domain/repository/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DownloadVideoUsecase {
  final HomeRepository _repository;

  DownloadVideoUsecase(this._repository);

  Future<Either<ServerException, DownloadVideoResponseModel>> call(
    DownloadVideoRequestModel request,
  ) async => _repository.downloadVideo(request);
}
