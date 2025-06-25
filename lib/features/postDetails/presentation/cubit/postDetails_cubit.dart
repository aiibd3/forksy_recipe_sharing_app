import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:forksy/core/utils/logs_manager.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../posts/data/repos/post_repo.dart';
import '../../../posts/domain/entities/comment.dart';
import '../../../posts/domain/entities/post.dart';
import '../../../posts/domain/repos/post_repo.dart';
import '../../../posts/presentation/cubit/post_cubit.dart';
import '../../../profile/data/repos/profile_repo.dart';
import '../../../profile/domain/entities/profile_user.dart';
import '../../../profile/domain/repos/profile_repo.dart';

part 'postDetails_state.dart';

class PostDetailsCubit extends Cubit<PostDetailsState> {
  final PostRepo postRepo;
  final ProfileRepo profileRepo;

  PostDetailsCubit({PostRepo? postRepo, ProfileRepo? profileRepo})
      : postRepo = postRepo ?? FirebasePostRepo(),
        profileRepo = profileRepo ?? FirebaseProfileRepo(),
        super(PostDetailsInitial());

  Future<void> fetchPostDetails(String postId) async {
    try {
      emit(PostDetailsLoading());
      final post = await postRepo.fetchPostById(postId);
      final postUser = await profileRepo.fetchProfileUser(post.userId);
      LogsManager.info("Fetched post details: $postId");
      emit(PostDetailsLoadedSuccess(post: post, postUser: postUser));
    } catch (e) {
      LogsManager.error("Error fetching post details: $e");
      emit(PostDetailsLoadedFailure("${"posts.fetchError".tr()}: $e"));
    }
  }

  Future<void> toggleLikePost(String postId, BuildContext context) async {
    try {
      final state = this.state;
      if (state is PostDetailsLoadedSuccess) {
        final currentUser =
            RepositoryProvider.of<AuthCubit>(context).currentUser;
        if (currentUser == null) {
          LogsManager.error("No user logged in");
          emit(PostDetailsLoadedFailure("posts.noUser".tr()));
          return;
        }
        await postRepo.toggleLikePost(postId, currentUser.uid);
        final updatedPost = await postRepo.fetchPostById(postId);
        emit(PostDetailsLoadedSuccess(
            post: updatedPost, postUser: state.postUser));
        LogsManager.info("Toggled like for post: $postId");
      }
    } catch (e) {
      LogsManager.error("Error toggling like: $e");
      emit(PostDetailsLoadedFailure("${"posts.likeError".tr()}: $e"));
    }
  }

  Future<void> addComment(String postId, Comment comment) async {
    try {
      final state = this.state;
      if (state is PostDetailsLoadedSuccess) {
        await postRepo.addComment(postId, comment);
        final updatedPost = await postRepo.fetchPostById(postId);
        emit(PostDetailsLoadedSuccess(
            post: updatedPost, postUser: state.postUser));
        LogsManager.info("Added comment to post: $postId");
      }
    } catch (e) {
      LogsManager.error("Error adding comment: $e");
      emit(PostDetailsLoadedFailure("${"posts.commentError".tr()}: $e"));
    }
  }

  void openNewComment(BuildContext context, String postId) {
    final currentUser = RepositoryProvider.of<AuthCubit>(context).currentUser;
    if (currentUser == null) {
      LogsManager.error("No user logged in");
      emit(PostDetailsLoadedFailure("posts.noUser".tr()));
      return;
    }

    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: TextField(
          controller: commentController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: "comments.enterComment".tr(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text("posts.cancel".tr()),
          ),
          TextButton(
            onPressed: () {
              if (commentController.text.isNotEmpty) {
                final newComment = Comment(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  postId: postId,
                  userId: currentUser.uid,
                  userName: currentUser.name,
                  text: commentController.text,
                  timesTamp: DateTime.now(),
                );
                addComment(postId, newComment);
                Navigator.pop(dialogContext);
              }
            },
            child: Text("comments.save".tr()),
          ),
        ],
      ),
    );
  }

  Future<void> deletePost(String postId, BuildContext context) async {
    try {
      final state = this.state;
      if (state is PostDetailsLoadedSuccess) {
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text("posts.deletePost".tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text("posts.cancel".tr()),
              ),
              TextButton(
                onPressed: () async {
                  await postRepo.deletePost(postId);
                  Navigator.pop(dialogContext);
                  Navigator.pop(context); // Return to previous screen
                  RepositoryProvider.of<PostCubit>(context)
                      .fetchAllPosts(); // Refresh posts
                  LogsManager.info("Deleted post: $postId");
                },
                child: Text("posts.delete".tr()),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      LogsManager.error("Error deleting post: $e");
      emit(PostDetailsLoadedFailure("${"posts.deleteError".tr()}: $e"));
    }
  }
}
