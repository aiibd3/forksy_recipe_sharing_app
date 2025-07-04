import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/extensions/context_extension.dart';
import 'package:forksy/core/utils/logs_manager.dart';

import '../../../../core/services/hive_storage.dart';
import '../../../../core/theme/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/data/repos/auth_repo.dart';
import '../cubit/splash_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    HiveStorage.init();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FirebaseAuthRepo(),
      child: BlocProvider(
        create: (context) => SplashCubit(
          authRepo: context.read<FirebaseAuthRepo>(),
        )..loadConfig(),
        child: BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state is GoToRouteState) {
              LogsManager.warning("Route: ${state.route}");
              context.goToReplace(state.route);
            }
          },
          child: const _SplashPageBody(),
        ),
      ),
    );
  }
}

class _SplashPageBody extends StatelessWidget {
  const _SplashPageBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ZoomIn(
          child: Center(
            child: SizedBox(
              width: context.width * 0.85,
              child: Image.asset(AppAssets.logoForksy),
            ),
          ),
        ),
      ),
    );
  }
}