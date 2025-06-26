import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forksy/features/profile/domain/entities/profile_user.dart';
import '../../../posts/domain/entities/post.dart';
import '../../domain/repos/search_repo.dart';

class FirebaseSearchRepo implements SearchRepo {
  @override
  Future<List<ProfileUser?>> searchUsers(String query) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection("users")
          .where("name", isGreaterThanOrEqualTo: query)
          .where("name", isLessThan: "$query\uf8ff")
          .get();

      return result.docs
          .map((doc) => ProfileUser.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception("Error searching users: $e");
    }
  }

  Future<List<Post?>> searchPosts(String query) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection("posts")
          .where("text", isGreaterThanOrEqualTo: query)
          .where("text", isLessThan: "$query\uf8ff")
          .get();

      return result.docs.map((doc) => Post.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception("Error searching posts: $e");
    }
  }
}
