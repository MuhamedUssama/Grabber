import 'package:flutter/material.dart';
import 'package:grabber/core/routes/app_router.dart';
import 'package:grabber/core/routes/routes_name.dart';

class Grabber extends StatelessWidget {
  const Grabber({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grabber',
      debugShowCheckedModeBanner: false,
      routes: AppRouter.routes(),
      initialRoute: RoutesName.homeScreen,
    );
  }
}
