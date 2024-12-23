part of 'onboarding_cubit.dart';

@immutable
sealed class OnboardingState {}

final class OnboardingInitial extends OnboardingState {}

final class OnboardingLoading extends OnboardingState {}

final class OnboardingLoadedSuccess extends OnboardingState {}

final class OnboardingLoadedFailure extends OnboardingState {
  final String error;

  OnboardingLoadedFailure(this.error);
}
