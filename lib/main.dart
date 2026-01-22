import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/di/di.dart';
import 'package:grabber/core/utils/backend_service.dart';
import 'package:grabber/core/utils/bloc_observer.dart';
import 'package:grabber/grabber_app.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions options = const WindowOptions(
    minimumSize: Size(800, 700),
    size: Size(1200, 700),
    center: true,
    title: "Grabber",
  );

  await windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  await windowManager.setPreventClose(true);

  configureDependencies();
  Bloc.observer = MyBlocObserver();

  await BackendService.startServer();

  runApp(GrabberApp());
}

class GrabberApp extends StatefulWidget {
  const GrabberApp({super.key});

  @override
  State<GrabberApp> createState() => _GrabberAppState();
}

class _GrabberAppState extends State<GrabberApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    BackendService.stopServer();
    await windowManager.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return const Grabber();
  }
}
