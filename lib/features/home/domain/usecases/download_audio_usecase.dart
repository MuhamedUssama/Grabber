import 'package:dartz/dartz.dart';
import 'package:grabber/core/network/exceptions.dart';
import 'package:grabber/features/home/data/models/request/download_audio_request_model.dart';
import 'package:grabber/features/home/domain/repository/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DownloadAudioUsecase {
  final HomeRepository _repository;
  const DownloadAudioUsecase(this._repository);

  Future<Either<ServerException, String>> call(
    DownloadAudioRequestModel request,
  ) async => _repository.downloadAudio(request);
}
