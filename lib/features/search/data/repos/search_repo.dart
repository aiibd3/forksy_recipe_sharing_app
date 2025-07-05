import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forksy/features/profile/domain/entities/profile_user.dart';
import '../../../posts/domain/entities/post.dart';
import '../../domain/repos/search_repo.dart';

class FirebaseSearchRepo implements SearchRepo {
  @override
  Future<List<ProfileUser>> searchUsers(String query) async {
    try {
      final result = await FirebaseFirestore.instance.collection("users").get();

      final filtered = result.docs
          .map((doc) => ProfileUser.fromJson(doc.data()))
          .where(
              (user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return filtered;
    } catch (e) {
      throw Exception("Error searching users: $e");
    }
  }

  @override
  Future<List<Post>> searchPosts(String query) async {
    try {
      final result = await FirebaseFirestore.instance.collection("posts").get();

      final filtered = result.docs
          .map((doc) => Post.fromJson(doc.data()))
          .where(
              (post) => post.text.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return filtered;
    } catch (e) {
      throw Exception("Error searching posts: $e");
    }
  }
}
