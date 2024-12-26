import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/firebase_error_handler.dart';
import '../../../../core/utils/logs_manager.dart';
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
      await firebaseFirestore.collection('users').doc(updatedUser.uid).update({
        'bio': updatedUser.bio,
        'profileImage': updatedUser.profileImage,
      });

      return updatedUser;

      // ?? return Future.value(updatedUser);
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
    }
    return null;
  }
}
