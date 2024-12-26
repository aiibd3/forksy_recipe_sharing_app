import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/errors/firebase_error_handler.dart';
import '../../../../core/utils/logs_manager.dart';
import '../../domain/repos/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  Future<String> uploadProfileImage(String path, String fileName) {
    return _uploadFile(path, fileName, 'profile_images');
  }

  @override
  Future<String?> uploadPostImage(String path, String fileName) {
    return _uploadFile(path, fileName, 'post_images');
  }

  Future<String> _uploadFile(
      String path, String fileName, String folder) async {
    try {
      if (path.isEmpty) {
        throw Exception("File path is invalid");
      }
      final file = File(path);
      final storageRef = firebaseStorage.ref().child(folder).child(fileName);
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => null);
      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
      throw Exception(errorHandler.errorMessage);
    } catch (e) {
      LogsManager.error("Unexpected error: $e");
      throw Exception("An unexpected error occurred.");
    }
  }
}
