import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forksy/core/utils/logs_manager.dart';

import '../../../../core/errors/firebase_error_handler.dart';
import '../../domain/entities/profile_user.dart';
import '../../domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<ProfileUser?> fetchProfileUser(String uid) async {
    if (uid.trim().isEmpty) {
      LogsManager.warning('fetchProfileUser called with empty uid');
      return null;
    }

    try {
      final userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        return ProfileUser.fromJson(userDoc.data()!);
      }

      // if (userDoc.exists) {
      //   final userData = userDoc.data();
      //   if (userData != null) {
      //     return ProfileUser.fromJson(userData);
          // return ProfileUser(
          //   bio: userData['bio'],
          //   uid: userData['uid'],
          //   name: userData['name'],
          //   email: userData['email'],
          //   profileImage: userData['profileImage'],
          // );
      //   }
      // }

      LogsManager.warning('No user found for uid: $uid');
      return null;
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error('Firestore error in fetchProfileUser: ${errorHandler.errorMessage}');
    } catch (e, stack) {
      LogsManager.error('Unexpected error in fetchProfileUser: $e\n$stack');
    }

    return null;
  }

  @override
  Future<ProfileUser?> updateProfileUser(ProfileUser updatedUser) async {
    try {
      LogsManager.info("Updating user in Firestore: ${updatedUser.toJson()}");
      await firebaseFirestore
          .collection('users')
          .doc(updatedUser.uid)
          .update(updatedUser.toJson());
      return updatedUser;
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
      throw Exception("Firebase error: ${errorHandler.errorMessage}");
    } catch (e) {
      LogsManager.error("Unexpected error: $e");
      throw Exception("Unexpected error occurred: $e");
    }
  }
}
