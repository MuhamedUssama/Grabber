import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabber/core/di/di.dart';
import 'package:grabber/core/utils/bloc_observer.dart';
import 'package:grabber/grabber_app.dart';

void main() {
  configureDependencies();
  Bloc.observer = MyBlocObserver();

  runApp(const Grabber());
}
