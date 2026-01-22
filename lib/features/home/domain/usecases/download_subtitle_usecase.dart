import 'package:dartz/dartz.dart';
import 'package:grabber/core/network/exceptions.dart';
import 'package:grabber/features/home/data/models/request/download_subtitle_request_model.dart';
import 'package:grabber/features/home/domain/repository/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DownloadSubtitleUsecase {
  final HomeRepository _repository;

  DownloadSubtitleUsecase(this._repository);

  Future<Either<ServerException, String>> call(
    DownloadSubtitleRequestModel request,
  ) async => _repository.downloadSubtitle(request);
}
