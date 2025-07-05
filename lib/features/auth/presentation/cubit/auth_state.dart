part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class Authenticated extends AuthState {
  final AppUser user;

  Authenticated(this.user);
}

final class UnAuthenticated extends AuthState {}

final class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}

final class AuthInvalidEmail extends AuthState {}

final class AuthInvalidCredentials extends AuthState {}

final class AuthEmailAlreadyInUse extends AuthState {}

final class AuthWeakPassword extends AuthState {}

final class AuthTooManyRequests extends AuthState {}

final class AuthNetworkError extends AuthState {}

final class AuthOperationNotAllowed extends AuthState {}
