import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/firebase_error_handler.dart';
import '../../../../core/utils/logs_manager.dart';
import '../../domain/entities/category_entities.dart';
import '../../domain/repos/category_repository.dart';

class FirebaseCategoryRepo implements CategoryRepo {
  final CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

  @override
  Future<List<CategoryEntity>> fetchCategories() async {
    try {
      final snapshot = await categoriesCollection.get();
      return snapshot.docs
          .map((doc) =>
              CategoryEntity.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
      throw Exception("Firebase error: ${errorHandler.errorMessage}");
    } catch (e) {
      LogsManager.error("Unknown error: $e");
      throw Exception("An unexpected error occurred: $e");
    }
  }


}
