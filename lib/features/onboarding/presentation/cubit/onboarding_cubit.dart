import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/routing/routes_name.dart';
import 'package:forksy/core/utils/logs_manager.dart';
import '../../../auth/domain/repos/auth_repo.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final AuthRepo authRepo;

  OnboardingCubit({required this.authRepo}) : super(OnboardingInitial());

  Future<void> completeOnboarding() async {
    emit(OnboardingLoading());
    try {
      final user = await authRepo.getCurrentUser();
      if (user != null) {
        emit(GoToRouteState(RoutesName.layout));
      } else {
        emit(GoToRouteState(RoutesName.auth));
      }
    } catch (e) {
      LogsManager.error('Error completing onboarding: $e');
      emit(OnboardingLoadedFailure('Failed to complete onboarding: $e'));
    }
  }
}
