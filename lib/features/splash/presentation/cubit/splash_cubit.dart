import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/routing/routes_name.dart';
import 'package:forksy/core/utils/logs_manager.dart';
import '../../../../core/services/hive_storage.dart';
import '../../../auth/domain/repos/auth_repo.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AuthRepo authRepo;

  SplashCubit({required this.authRepo}) : super(SplashInitial());

  Future<void> loadConfig() async {
    await Future.delayed(const Duration(seconds: 3));

    try {

      // Initialize HiveStorage
      await HiveStorage.init();

      // Check if it's the user's first time
      if (HiveStorage.isFirstTime()) {
        emit(GoToRouteState(RoutesName.onboarding));
        return;
      }

      // If not first time, check authentication status
      final user = await authRepo.getCurrentUser();

      if (user != null) {
        emit(GoToRouteState(RoutesName.layout));
      } else {
        emit(GoToRouteState(RoutesName.onboarding));
        // emit(GoToRouteState(RoutesName.auth));
      }
    } catch (e) {
      LogsManager.error('Error in loadConfig: $e');
      emit(GoToRouteState(RoutesName.auth));
    }
  }
}