import 'package:flutter/material.dart';
import 'package:grabber/core/di/di.dart';
import 'package:grabber/grabber_app.dart';

void main() {
  configureDependencies();

  runApp(const Grabber());
}
