part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoadedSuccess extends ProfileState {}

final class ProfileLoadedFailure extends ProfileState {
  final String error;

  ProfileLoadedFailure(this.error);
}
