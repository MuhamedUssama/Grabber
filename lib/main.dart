import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/di/di.dart';
import 'package:grabber/core/utils/bloc_observer.dart';
import 'package:window_manager/window_manager.dart';
import 'package:grabber/grabber_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions options = const WindowOptions(
    minimumSize: Size(800, 600),
    size: Size(1200, 600),
    center: true,
    title: "Grabber",
  );

  windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  configureDependencies();
  Bloc.observer = MyBlocObserver();

  runApp(const Grabber());
}
