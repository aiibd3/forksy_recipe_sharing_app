import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/features/storage/domain/repos/storage_repo.dart';

import '../../../../core/errors/firebase_error_handler.dart';
import '../../../../core/utils/logs_manager.dart';
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

  // create a new post
  Future<void> createPost(Post post, {String? imagePath}) async {
    String? imageUrl;

    try {
      // Upload image if imagePath is provided
      if (imagePath != null) {
        emit(PostLoading());
        imageUrl = await storageRepo.uploadPostImage(imagePath, post.id);
      }

      // Add the image URL to the post
      final newPost = post.copyWith(imageUrl: imageUrl);

      // Save post to Firestore
      await postRepo.createPost(newPost);

      // Optionally include the post in the state
      emit(PostLoaded([newPost]));
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
      emit(PostFailure(errorHandler.errorMessage));
    } catch (e) {
      LogsManager.error("Unknown error: $e");
      emit(PostFailure("An unexpected error occurred"));
    }
  }

  Future<void> fetchAllPosts() async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostLoaded(posts));
    } catch (e) {
      LogsManager.error(e.toString());
      emit(PostFailure(e.toString()));
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
      throw Exception("Firebase error: ${errorHandler.errorMessage}");
    }
  }

  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
    } catch (e) {
      emit(PostFailure(e.toString()));
      LogsManager.error(e.toString());
    }
  }

  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);

      await fetchAllPosts();
    } catch (e) {
      emit(PostFailure(e.toString()));
      LogsManager.error(e.toString());
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
      await fetchAllPosts();
    } catch (e) {
      emit(PostFailure(e.toString()));
      LogsManager.error(e.toString());
    }
  }
}
