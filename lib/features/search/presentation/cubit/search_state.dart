part of 'search_cubit.dart';

sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchUsersLoaded extends SearchState {
  final List<ProfileUser?> users;

  SearchUsersLoaded(this.users);
}

final class SearchPostsLoaded extends SearchState {
  final List<Post?> posts;

  SearchPostsLoaded(this.posts);
}

final class SearchError extends SearchState {
  final String error;

  SearchError(this.error);
}