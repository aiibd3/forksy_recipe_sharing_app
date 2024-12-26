part of 'storage_cubit.dart';

@immutable
sealed class StorageState {}

final class StorageInitial extends StorageState {}

final class StorageLoading extends StorageState {}

final class StorageLoadedSuccess extends StorageState {}

final class StorageLoadedFailure extends StorageState {
  final String error;

  StorageLoadedFailure(this.error);
}
