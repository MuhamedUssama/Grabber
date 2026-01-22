import 'package:dartz/dartz.dart';
import 'package:grabber/core/network/exceptions.dart';
import 'package:grabber/features/home/domain/repository/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CancelTaskUseCase {
  final HomeRepository _repository;

  CancelTaskUseCase(this._repository);

  Future<Either<ServerException, void>> call(String taskId) async =>
      _repository.cancelTask(taskId);
}
