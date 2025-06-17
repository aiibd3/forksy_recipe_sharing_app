import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forksy/core/utils/logs_manager.dart';
import 'package:forksy/features/posts/domain/entities/comment.dart';

import '../../../../core/errors/firebase_error_handler.dart';
import '../../domain/entities/post.dart';
import '../../domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
      throw Exception("Firebase error: ${errorHandler.errorMessage}");
    } catch (e) {
      LogsManager.error("Unknown error: $e");
      throw Exception("An unexpected error occurred: $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await postsCollection.doc(postId).delete();
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
      throw Exception("Firebase error: ${errorHandler.errorMessage}");
    }
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      final postSnapshot =
          await postsCollection.orderBy('timestamp', descending: true).get();

      final List<Post> allPosts = postSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return allPosts;
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
      throw Exception("Firebase error: ${errorHandler.errorMessage}");
    }
  }

  @override
  Future<List<Post>> fetchPostByUserId(String userId) async {
    try {
      final postSnapshot =
          await postsCollection.where('userId', isEqualTo: userId).get();
      final userPosts = postSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return userPosts;
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
      throw Exception("Firebase error: ${errorHandler.errorMessage}");
    }
  }

  @override
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      final postDoc = await postsCollection.doc(postId).get();
      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        final isLiked = post.likes.contains(userId);

        if (isLiked) {
          post.likes.remove(userId);
        } else {
          post.likes.add(userId);
        }

        await postsCollection.doc(postId).update({'likes': post.likes});
      } else {
        LogsManager.error("Post not found");
        throw Exception("Post not found");
      }
    } catch (e) {
      LogsManager.error("Unknown error: $e");
      throw Exception("Post not found");
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try {
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        // convert json to Post object
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // add the new comment
        post.comments.add(comment);

        // update post document in firestore
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList()
        });
      } else {
        LogsManager.error("Post not found");
        throw Exception("Post not found");
      }
    } catch (e) {
      LogsManager.error("Unknown error: $e");
      throw Exception("Post not found");
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      // get post document
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        // convert post document to Post object
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // add the new comment
        post.comments.removeWhere((comment) => comment.id == commentId);

        // update post document in firestore
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList()
        });
      } else {
        LogsManager.error("Post not found");
        throw Exception("Post not found");
      }
    } catch (e) {
      LogsManager.error("Unknown error: $e");
      throw Exception("Post not found");
    }
  }
}
