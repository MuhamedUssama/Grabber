import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/di/di.dart';
import 'package:grabber/core/routes/routes_name.dart';
import 'package:grabber/features/home/presentation/view/home_screen.dart';
import 'package:grabber/features/home/presentation/view_model/home_screen_view_model.dart';
import 'package:grabber/features/splash/splash_screen.dart';

abstract class AppRouter {
  static Map<String, Widget Function(BuildContext context)> routes() {
    return {
      RoutesName.homeScreen:
          (context) => BlocProvider(
            create: (context) => getIt.get<HomeScreenViewModel>(),
            child: HomeScreen(),
          ),
      RoutesName.splashScreen: (context) => SplashScreen(),
    };
  }
}
