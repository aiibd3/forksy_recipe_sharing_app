import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';

abstract class PostRepo {
  Future<void> createPost(Post post);

  Future<List<Post>> fetchAllPosts();

  Future<List<Post>> fetchPostsByCategory(String category);

  Future<void> deletePost(String postId);

  Future<void> toggleLikePost(String postId, String userId);

  Future<void> addComment(String postId, Comment comment);

  Future<void> deleteComment(String postId, String commentId);
}
