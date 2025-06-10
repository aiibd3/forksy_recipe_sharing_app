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
    try {
      final userDoc =
          await firebaseFirestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          return ProfileUser.fromJson(userData);
          // return ProfileUser(
          //   bio: userData['bio'],
          //   uid: userData['uid'],
          //   name: userData['name'],
          //   email: userData['email'],
          //   profileImage: userData['profileImage'],
          // );
        }
      }

      return null;
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
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
