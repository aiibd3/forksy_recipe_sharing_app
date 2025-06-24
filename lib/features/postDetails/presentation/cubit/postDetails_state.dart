part of 'postDetails_cubit.dart';

@immutable
abstract class PostDetailsState {}

class PostDetailsInitial extends PostDetailsState {}

class PostDetailsLoading extends PostDetailsState {}

class PostDetailsLoadedSuccess extends PostDetailsState {
  final Post post;
  final ProfileUser? postUser;

  PostDetailsLoadedSuccess({
    required this.post,
    required this.postUser,
  });
}

class PostDetailsLoadedFailure extends PostDetailsState {
  final String error;

  PostDetailsLoadedFailure(this.error);
}
