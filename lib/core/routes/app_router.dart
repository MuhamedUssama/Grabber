import 'package:flutter/material.dart';
import 'package:grabber/core/routes/routes_name.dart';
import 'package:grabber/features/home/presentation/view/home_screen.dart';

abstract class AppRouter {
  static Map<String, Widget Function(BuildContext context)> routes() {
    return {RoutesName.homeScreen: (context) => HomeScreen()};
  }
}
