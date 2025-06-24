class CategoryEntity {
  final String id;
  final String title;
  final String imageUrl;

  CategoryEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'imageUrl': imageUrl,
  };

  factory CategoryEntity.fromJson(Map<String, dynamic> json) => CategoryEntity(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    imageUrl: json['imageUrl'] ?? '',
  );
}