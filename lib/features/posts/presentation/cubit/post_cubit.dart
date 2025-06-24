import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:forksy/core/errors/firebase_error_handler.dart';
import 'package:forksy/core/utils/logs_manager.dart';
import '../../../storage/domain/repos/storage_repo.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';
import '../../domain/repos/post_repo.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({
    required this.postRepo,
    required this.storageRepo,
  }) : super(PostInitial());

  Future<void> createPost(Post post, {String? imagePath}) async {
    const validCategories = [
      'eastern',
      'western',
      'italian',
      'desserts',
      'asian'
    ];
    if (!validCategories.contains(post.categories)) {
      LogsManager.error("Invalid category: ${post.categories}");
      emit(PostFailure("posts.invalidCategory".tr()));
      return;
    }
    String? imageUrl;
    try {
      if (imagePath != null) {
        emit(PostUpLoading());
        imageUrl = await storageRepo.uploadPostImage(imagePath, post.id);
      }
      final newPost = post.copyWith(imageUrl: imageUrl);
      await postRepo.createPost(newPost);
      emit(PostLoaded([newPost]));
      LogsManager.info("Post created: ${newPost.id}");
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
      emit(PostFailure(
          "${"posts.uploadError".tr()}: ${errorHandler.errorMessage}"));
    } catch (e) {
      LogsManager.error("Unknown error: $e");
      emit(PostFailure("${"posts.unexpectedError".tr()}: $e"));
    }
  }

  Future<void> fetchAllPosts() async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostLoaded(posts));
      LogsManager.info("Fetched ${posts.length} posts for all categories");
    } catch (e) {
      LogsManager.error("Fetch all posts error: $e");
      emit(PostFailure("${"posts.fetchError".tr()}: $e"));
    }
  }

  Future<void> fetchPostsByCategory(String category) async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fetchPostsByCategory(category);
      emit(PostLoaded(posts));
      LogsManager.info("Fetched ${posts.length} posts for category: $category");
    } catch (e) {
      LogsManager.error("Fetch posts by category error: $category, $e");
      emit(PostFailure("${"posts.fetchError".tr()}: $e"));
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
      await fetchAllPosts();
      LogsManager.info("Post deleted: $postId");
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
      emit(PostFailure(
          "${"posts.deleteError".tr()}: ${errorHandler.errorMessage}"));
    }
  }

  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
      await fetchAllPosts();
      LogsManager.info("Toggled like for post: $postId");
    } catch (e) {
      emit(PostFailure("${"posts.likeError".tr()}: $e"));
      LogsManager.error("Toggle like error: $e");
    }
  }

  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchAllPosts();
      LogsManager.info("Added comment to post: $postId");
    } catch (e) {
      emit(PostFailure("${"posts.commentError".tr()}: $e"));
      LogsManager.error("Add comment error: $e");
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
      await fetchAllPosts();
      LogsManager.info("Deleted comment $commentId from post: $postId");
    } catch (e) {
      emit(PostFailure("${"posts.commentError".tr()}: $e"));
      LogsManager.error("Delete comment error: $e");
    }
  }
}
