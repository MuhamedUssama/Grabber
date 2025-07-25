// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pretty_dio_logger/pretty_dio_logger.dart' as _i528;

import '../../features/home/data/data_source/home_data_source.dart' as _i68;
import '../../features/home/data/data_source/home_data_source_impl.dart'
    as _i291;
import '../../features/home/data/repo_impl/home_repository_impl.dart' as _i293;
import '../../features/home/domain/repository/home_repository.dart' as _i541;
import '../../features/home/domain/usecases/download_audio_usecase.dart'
    as _i898;
import '../../features/home/domain/usecases/download_video_usecase.dart'
    as _i513;
import '../../features/home/domain/usecases/download_video_without_audio_usecase.dart'
    as _i117;
import '../../features/home/domain/usecases/get_video_info_usecase.dart'
    as _i1016;
import '../../features/home/presentation/view_model/home_screen_view_model.dart'
    as _i181;
import '../network/network_module.dart' as _i200;
import '../network/retrofit_client.dart' as _i74;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.factory<_i528.PrettyDioLogger>(() => networkModule.prettyDioLogger());
    gh.lazySingleton<_i361.Dio>(() => networkModule.provideDio());
    gh.singleton<_i74.RetrofitClient>(
      () => _i74.RetrofitClient(gh<_i361.Dio>()),
    );
    gh.factory<_i68.HomeDataSource>(
      () => _i291.HomeDataSourceImpl(gh<_i74.RetrofitClient>()),
    );
    gh.factory<_i541.HomeRepository>(
      () => _i293.HomeRepositoryImpl(gh<_i68.HomeDataSource>()),
    );
    gh.factory<_i898.DownloadAudioUsecase>(
      () => _i898.DownloadAudioUsecase(gh<_i541.HomeRepository>()),
    );
    gh.factory<_i513.DownloadVideoUsecase>(
      () => _i513.DownloadVideoUsecase(gh<_i541.HomeRepository>()),
    );
    gh.factory<_i117.DownloadVideoWithoutAudioUsecase>(
      () => _i117.DownloadVideoWithoutAudioUsecase(gh<_i541.HomeRepository>()),
    );
    gh.factory<_i1016.GetVideoInfoUsecase>(
      () => _i1016.GetVideoInfoUsecase(gh<_i541.HomeRepository>()),
    );
    gh.factory<_i181.HomeScreenViewModel>(
      () => _i181.HomeScreenViewModel(
        gh<_i1016.GetVideoInfoUsecase>(),
        gh<_i898.DownloadAudioUsecase>(),
        gh<_i513.DownloadVideoUsecase>(),
        gh<_i117.DownloadVideoWithoutAudioUsecase>(),
      ),
    );
    return this;
  }
}

class _$NetworkModule extends _i200.NetworkModule {}
