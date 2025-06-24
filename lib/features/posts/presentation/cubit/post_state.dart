part of 'post_cubit.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostUpLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;

  PostLoaded(this.posts);
}

class PostFailure extends PostState {
  final String error;

  PostFailure(this.error);
}
