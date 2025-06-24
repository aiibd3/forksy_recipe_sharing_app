import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forksy/core/utils/logs_manager.dart';
import '../../../../core/errors/firebase_error_handler.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';
import '../../domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      const validCategories = [
        'eastern',
        'western',
        'italian',
        'desserts',
        'asian'
      ];
      if (!validCategories.contains(post.categories)) {
        LogsManager.error("Invalid category: ${post.categories}");
        throw Exception("Invalid category: ${post.categories}");
      }
      await postsCollection.doc(post.id).set(post.toJson());
      LogsManager.info("Post created successfully: ${post.id}");
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
      LogsManager.info("Post deleted successfully: $postId");
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
      LogsManager.info("Fetched ${allPosts.length} posts");
      return allPosts;
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
      throw Exception("Firebase error: ${errorHandler.errorMessage}");
    }
  }

  Future<List<Post>> fetchPostByUserId(String userId) async {
    try {
      final postSnapshot =
          await postsCollection.where('userId', isEqualTo: userId).get();
      final userPosts = postSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      LogsManager.info("Fetched ${userPosts.length} posts for user: $userId");
      return userPosts;
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
      throw Exception("Firebase error: ${errorHandler.errorMessage}");
    }
  }

  @override
  Future<List<Post>> fetchPostsByCategory(String category) async {
    try {
      LogsManager.info("Fetching posts for category: $category");
      final postSnapshot = await postsCollection
          .where('categories', isEqualTo: category)
          .orderBy('timestamp', descending: true)
          .get();
      final categoryPosts = postSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      LogsManager.info(
          "Fetched ${categoryPosts.length} posts for category: $category");
      return categoryPosts;
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(
          "Firebase error for category $category: ${errorHandler.errorMessage}");
      throw Exception("Firebase error: ${errorHandler.errorMessage}");
    } catch (e) {
      LogsManager.error("Unknown error for category $category: $e");
      throw Exception("An unexpected error occurred: $e");
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
        LogsManager.info("Toggled like for post: $postId, user: $userId");
      } else {
        LogsManager.error("Post not found: $postId");
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
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
        post.comments.add(comment);
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList()
        });
        LogsManager.info("Added comment to post: $postId");
      } else {
        LogsManager.error("Post not found: $postId");
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
      final postDoc = await postsCollection.doc(postId).get();
      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);
        post.comments.removeWhere((comment) => comment.id == commentId);
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList()
        });
        LogsManager.info("Deleted comment $commentId from post: $postId");
      } else {
        LogsManager.error("Post not found: $postId");
        throw Exception("Post not found");
      }
    } catch (e) {
      LogsManager.error("Unknown error: $e");
      throw Exception("Post not found");
    }
  }

  @override
  Future<Post> fetchPostById(String postId) async {
    try {
      final doc = await postsCollection.doc(postId).get();
      if (!doc.exists) {
        throw Exception("Post not found");
      }
      return Post.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      LogsManager.error("Error fetching post by ID: $e");
      throw Exception("Error fetching post by ID: $e");
    }
  }
}
