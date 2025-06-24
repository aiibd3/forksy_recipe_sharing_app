import '../entities/category_entities.dart';

abstract class CategoryRepo {
  Future<List<CategoryEntity>> fetchCategories();
}
