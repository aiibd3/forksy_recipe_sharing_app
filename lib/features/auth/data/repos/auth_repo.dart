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
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      DocumentSnapshot userDoc = await firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        LogsManager.error("User document not found for uid: ${userCredential.user!.uid}");
        return null;
      }

      AppUser user = AppUser(
        email: email,
        name: userDoc['name'] ?? userCredential.user?.displayName ?? 'Unknown',
        uid: userCredential.user!.uid,
      );

      LogsManager.info("User logged in: ${user.uid}");
      return user;
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error("Login error: ${errorHandler.errorMessage}");
      throw Exception(errorHandler.errorMessage);
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(String name, String email, String password) async {
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

      LogsManager.info("User registered: ${user.uid}");
      return user;
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error("Registration error: ${errorHandler.errorMessage}");
      throw Exception(errorHandler.errorMessage);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
      LogsManager.info("User logged out");
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error("Logout error: ${errorHandler.errorMessage}");
      throw Exception(errorHandler.errorMessage);
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;

    if (firebaseUser == null) {
      LogsManager.info("No current user found");
      return null;
    }

    DocumentSnapshot userDoc =
    await firebaseFirestore.collection("users").doc(firebaseUser.uid).get();

    if (!userDoc.exists) {
      LogsManager.error("User document not found for uid: ${firebaseUser.uid}");
      return null;
    }

    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? 'Unknown',
      name: userDoc['name'] ?? firebaseUser.displayName ?? 'Unknown',
    );
  }
}