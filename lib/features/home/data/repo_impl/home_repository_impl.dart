import 'package:dartz/dartz.dart';
import 'package:grabber/core/network/exceptions.dart';
import 'package:grabber/core/utils/connectivity_helper.dart';
import 'package:grabber/features/home/data/models/response/get_video_info_model.dart';
import 'package:grabber/features/home/domain/repository/home_repository.dart';
import 'package:injectable/injectable.dart';

import '../data_source/home_data_source.dart';

@Injectable(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource _dataSource;

  HomeRepositoryImpl(this._dataSource);

  @override
  Future<Either<ServerException, GetVideoInfoModel>> getVideoInfo(
    String url,
  ) async {
    if (await ConnectivityHelper.checkInternetConnection()) {
      final either = await _dataSource.getVideoInfo(url);

      return either.fold(
        (error) => Left(ServerException(error.message)),
        (videoInfo) => Right(videoInfo),
      );
    } else {
      return Left(NoInternetConnectionException());
    }
  }
}
