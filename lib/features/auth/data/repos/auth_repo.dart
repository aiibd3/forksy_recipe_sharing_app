import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:forksy/core/utils/logs_manager.dart';
import 'package:forksy/features/auth/domain/entities/app_user.dart';

import '../../../../core/errors/firebase_error_handler.dart';
import '../../domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      //* Attempt sign-in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      //* Create AppUser instance
      AppUser user = AppUser(
        email: email,
        name: userCredential.user?.displayName ?? 'Unknown',
        uid: userCredential.user!.uid,
      );

      return user;
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
    }
    return null;
  }

  @override
  Future<AppUser?> registerWithEmailPassword(String name, String email,
      String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.updateDisplayName(name);

      AppUser user = AppUser(
        email: email,
        name: name,
        uid: userCredential.user!.uid,
      );

      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(user.toJson());

      return user;
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;

    if (firebaseUser != null) {
      return AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? 'Unknown',
        name: firebaseUser.displayName ?? 'Unknown',
      );
    }
    return null;
  }
}
