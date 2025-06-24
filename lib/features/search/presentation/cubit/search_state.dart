part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchLoaded extends SearchState {
  final List<ProfileUser?> users;

  SearchLoaded(this.users);
}

final class SearchError extends SearchState {
  final String error;

  SearchError(this.error);
}
