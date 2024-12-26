import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/features/auth/domain/repos/auth_repo.dart';

import '../../../../core/routing/routes_name.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AuthRepo authRepo;

  SplashCubit({required this.authRepo}) : super(SplashInitial());

  Future<void> loadConfig() async {
    await Future.delayed(const Duration(seconds: 3));

    try {

      final user = await authRepo.getCurrentUser();

      if (user != null) {
        emit(GoToRouteState(RoutesName.layout));
      } else {
        emit(GoToRouteState(RoutesName.auth));
      }
    } catch (e) {
      emit(GoToRouteState(RoutesName.auth));
    }
  }
}
