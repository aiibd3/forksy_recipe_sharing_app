import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/extensions/context_extension.dart';
import 'package:logger/logger.dart';

import '../../../../core/routing/routes_name.dart';
import '../../../../core/theme/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/splash_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (mounted) {
          context.goToReplace(RoutesName.auth);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..loadConfig(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is GoToRouteState) {
            context.goToReplace(state.route);
          }
        },
        child: const _SplashPageBody(),
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
      backgroundColor: AppColors.primaryColor,
      body: ZoomIn(
        child: Center(
          child: SizedBox(
            width: context.width * 0.5,
            child: Image.asset(AppAssets.logoForksy),
          ),
        ),
      ),
    );
  }
}
