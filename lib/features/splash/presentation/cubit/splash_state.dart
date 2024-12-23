part of 'splash_cubit.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

final class GoToRouteState extends SplashState {
  final String route;

  GoToRouteState(this.route);
}
