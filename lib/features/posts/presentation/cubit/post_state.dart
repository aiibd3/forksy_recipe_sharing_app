part of 'post_cubit.dart';

@immutable
sealed class PostState {}

final class PostInitial extends PostState {}

final class PostLoading extends PostState {}
final class PostUpLoading extends PostState {}

final class PostLoaded extends PostState {
  final List<Post> posts;

  PostLoaded(this.posts);
}

final class PostFailure extends PostState {
  final String error;

  PostFailure(this.error);
}
