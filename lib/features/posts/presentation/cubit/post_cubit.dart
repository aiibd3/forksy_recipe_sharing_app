import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:forksy/core/errors/firebase_error_handler.dart';
import 'package:forksy/core/utils/logs_manager.dart';
import '../../../../core/services/notification_service.dart';
import '../../../auth/domain/entities/app_user.dart';
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

      await NotificationService.showNotification(
        title: "📝 منشور جديد",
        body: "لقد أنشأت منشورًا جديدًا: ${post.text}",
      );
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

  Future<void> toggleLikePost(String postId, AppUser currentUser) async {
    try {
      await postRepo.toggleLikePost(postId, currentUser.uid);
      await fetchAllPosts();

      final post = await postRepo.fetchPostById(postId);

      // إضافة إشعار للمستخدم الحالي
      final isLiked = post.likes.contains(currentUser.uid);
      await NotificationService.showNotification(
        title: "❤️ إعجاب",
        body: "لقد ${isLiked ? 'أعجبت' : 'ألغيت إعجابك'} بمنشور: ${post.text}",
      );

      // الإشعار للمستخدم الآخر (إذا كان مختلفًا)
      if (post.userId != currentUser.uid) {
        final postOwnerDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(post.userId)
            .get();

        final fcmToken = postOwnerDoc.data()?['fcmToken'] as String?;
        if (fcmToken != null && fcmToken.isNotEmpty) {
          await NotificationService.showNotification(
            title: "❤️ إعجاب جديد",
            body: "${currentUser.name} أعجب بمنشورك: ${post.text}",
          );
        }
      }

      LogsManager.info("Toggled like for post: $postId");
    } catch (e) {
      emit(PostFailure("${"posts.likeError".tr()}: $e"));
      LogsManager.error("Toggle like error: $e");
    }
  }

  Future<void> addComment(
      String postId, Comment comment, AppUser currentUser) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchAllPosts();

      final post = await postRepo.fetchPostById(postId);

      // إضافة إشعار للمستخدم الحالي
      await NotificationService.showNotification(
        title: "💬 تعليق جديد",
        body: "لقد أضفت تعليقًا على منشور: ${post.comments.last.text}",
      );

      // الإشعار للمستخدم الآخر (إذا كان مختلفًا)
      if (post.userId != currentUser.uid) {
        final postOwnerDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(post.userId)
            .get();

        final fcmToken = postOwnerDoc.data()?['fcmToken'] as String?;
        if (fcmToken != null && fcmToken.isNotEmpty) {
          await NotificationService.showNotification(
            title: "💬 تعليق جديد",
            body: "${currentUser.name} كتب تعليق على منشورك: ${comment.text}",
          );
        }
      }

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
