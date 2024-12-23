part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthLoadedSuccess extends AuthState {}

final class AuthLoadedFailure extends AuthState {
  final String error;

  AuthLoadedFailure(this.error);
}
