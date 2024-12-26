import 'package:flutter/material.dart';
import 'package:forksy/core/routing/routes_name.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/layout/presentation/pages/layout_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RoutesName.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RoutesName.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutesName.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: RoutesName.auth,
        name: 'auth',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutesName.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RoutesName.layout,
        name: 'layout',
        builder: (context, state) => const LayoutPage(),
        routes: [
          GoRoute(
            path: RoutesName.profile,
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
            // routes: [
              // GoRoute(
              //   path: RoutesName.settings,
              //   name: 'settings',
              //   builder: (context, state) => const EditProfilePage(
              //     user: ,
              //   ),
              // ),
            // ],
          ),
          // *+++++++++++++++++
          // GoRoute(
          //   path: RoutesName.settings,
          //   name: 'settings',
          //   builder: (context, state) => const SettingsPage(),
          // ),
        ],
      ),
    ],
  );
}
