import 'package:flutter/material.dart';
import 'package:forksy/core/routing/routes_name.dart';
import 'package:forksy/features/layout/presentation/widgets/profile/settings_section.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/layout/presentation/pages/layout_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
// import '../../features/settings/presentation/pages/settings_page.dart'; // If needed

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RoutesName.splash:
      return MaterialPageRoute(builder: (_) => const SplashPage());

    case RoutesName.onboarding:
      return MaterialPageRoute(builder: (_) => const OnboardingPage());

    case RoutesName.auth:
      return MaterialPageRoute(builder: (_) => const LoginPage());

    case RoutesName.register:
      return MaterialPageRoute(builder: (_) => const RegisterPage());

    case RoutesName.layout:
      return MaterialPageRoute(builder: (_) => const LayoutPage());

    case RoutesName.profile:
      return MaterialPageRoute(builder: (_) => const ProfilePage());

    case RoutesName.profileFullPath:
      return MaterialPageRoute(builder: (_) => const ProfilePage());

    case RoutesName.settings:
      return MaterialPageRoute(builder: (_) => const SettingsSection());

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('404 | Page Not Found')),
        ),
      );
  }
}
