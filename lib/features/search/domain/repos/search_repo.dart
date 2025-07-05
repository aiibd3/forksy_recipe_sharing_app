import '../../../posts/domain/entities/post.dart';
import '../../../profile/domain/entities/profile_user.dart';

abstract class SearchRepo {
  Future<List<ProfileUser?>> searchUsers(String query);

  Future<List<Post>> searchPosts(String query);
}
