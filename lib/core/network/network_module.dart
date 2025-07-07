import 'package:dio/dio.dart';
import 'package:grabber/core/di/di.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio provideDio() {
    Dio dio = Dio();

    dio.options.connectTimeout = const Duration(days: 1);
    dio.options.receiveTimeout = const Duration(days: 1);
    dio.interceptors.add(getIt<PrettyDioLogger>());

    return dio;
  }

  @injectable
  PrettyDioLogger prettyDioLogger() {
    return PrettyDioLogger(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
      error: true,
    );
  }
}
