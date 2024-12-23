import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'core/routing/app_router.dart';

GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class ForksyApp extends StatelessWidget {
  const ForksyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp.router(
          scaffoldMessengerKey: scaffoldMessengerKey,
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          title: 'Forksy App',
        );
      },
    );
  }
}
