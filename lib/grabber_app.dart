import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grabber/core/l10n/localization/app_localizations.dart';
import 'package:grabber/core/routes/app_router.dart';
import 'package:grabber/core/routes/routes_name.dart';
import 'package:grabber/core/theme/app_theme.dart';

class Grabber extends StatelessWidget {
  const Grabber({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grabber',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.darkTheme,
      supportedLocales: [Locale('en'), Locale('ar')],
      locale: Locale('en'),
      routes: AppRouter.routes(),
      initialRoute: RoutesName.splashScreen,
    );
  }
}
