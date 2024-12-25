import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routing/routes_name.dart';
import '../../../../core/services/hive_storage.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> loadConfig() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
    try {
      var isFirstTime = HiveStorage.isFirstTime();

      if (isFirstTime) {
        emit(
          GoToRouteState(RoutesName.layout),
        );
      }


    } catch (e) {
      emit(
        GoToRouteState(RoutesName.auth),
      );
    }
  }
}
