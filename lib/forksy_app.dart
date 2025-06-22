import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'core/routing/app_router.dart';
import 'core/routing/routes_name.dart';

GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class ForksyApp extends StatelessWidget {
  const ForksyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          scaffoldMessengerKey: scaffoldMessengerKey,
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Forksy App',
          initialRoute: RoutesName.splash,
          onGenerateRoute: generateRoute,
        );
      },
    );
  }
}
