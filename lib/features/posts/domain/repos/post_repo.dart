import '../entities/post.dart';

abstract class PostRepo {
  Future<List<Post>> fetchAllPosts();

  Future<void> createPost(Post post);

  Future<void> deletePost(String postId);

  Future<void> fetchPostByUserId(String userId);

  Future<void> toggleLikePost(String postId, String userId);
}
