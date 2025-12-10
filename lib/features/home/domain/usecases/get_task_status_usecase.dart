import 'package:dartz/dartz.dart';
import 'package:grabber/core/network/exceptions.dart';
import 'package:grabber/features/home/data/models/response/download_status_response_model.dart';
import 'package:grabber/features/home/domain/repository/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTaskStatusUseCase {
  final HomeRepository _repository;

  GetTaskStatusUseCase(this._repository);

  Future<Either<ServerException, DownloadStatusResponseModel>> call(
    String taskId,
  ) async => _repository.getTaskStatus(taskId);
}
