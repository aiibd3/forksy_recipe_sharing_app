import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forksy/core/utils/logs_manager.dart';

import '../../../../core/errors/firebase_error_handler.dart';
import '../../domain/entities/profile_user.dart';
import '../../domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

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
        LogsManager.info('Fetched user from Firestore: ${userDoc.data()}');
        return ProfileUser.fromJson(userDoc.data()!);
      }

      LogsManager.warning('No user found for uid: $uid');
      return null;
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(
          'Firestore error in fetchProfileUser: ${errorHandler.errorMessage}');
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

  @override
  Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    try {
      await firebaseFirestore.runTransaction((transaction) async {
        final currentUserRef =
            firebaseFirestore.collection('users').doc(currentUserId);
        final targetUserRef =
            firebaseFirestore.collection('users').doc(targetUserId);

        final currentUserDoc = await transaction.get(currentUserRef);
        final targetUserDoc = await transaction.get(targetUserRef);

        if (!currentUserDoc.exists || !targetUserDoc.exists) {
          throw Exception("User not found");
        }

        final currentUserData = currentUserDoc.data()!;
        final List<String> currentUserFollowing =
            List<String>.from(currentUserData['following'] ?? []);

        if (currentUserFollowing.contains(targetUserId)) {
          transaction.update(currentUserRef, {
            'following': FieldValue.arrayRemove([targetUserId])
          });
          transaction.update(targetUserRef, {
            'followers': FieldValue.arrayRemove([currentUserId])
          });
        } else {
          transaction.update(currentUserRef, {
            'following': FieldValue.arrayUnion([targetUserId])
          });
          transaction.update(targetUserRef, {
            'followers': FieldValue.arrayUnion([currentUserId])
          });
        }
      });

      LogsManager.info("Follow toggled successfully for user: $targetUserId");
    } catch (e, stack) {
      LogsManager.error("Error toggling follow: $e\n$stack");
      throw Exception("Failed to toggle follow: $e");
    }
  }
}



