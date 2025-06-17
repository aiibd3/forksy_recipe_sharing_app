import 'package:cloud_firestore/cloud_firestore.dart';

import 'comment.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timestamp;
  final List<String> likes;
  final List<Comment> comments;
  final bool isLiked;
  final bool isDisliked;
  final bool isCommented;
  final bool isSaved;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.isDisliked,
    required this.isCommented,
    required this.isSaved,
  });

  Post copyWith({
    String? id,
    String? userId,
    String? userName,
    String? text,
    String? imageUrl,
    DateTime? timestamp,
    List<String>? likes,
    List<Comment>? comments,
    bool? isLiked,
    bool? isDisliked,
    bool? isCommented,
    bool? isSaved,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
      isCommented: isCommented ?? this.isCommented,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'isLiked': isLiked,
      'isDisliked': isDisliked,
      'isCommented': isCommented,
      'isSaved': isSaved,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    final List<Comment> comments = (json['comments'] as List<dynamic>?)
            ?.map((commentJson) => Comment.fromJson(commentJson))
            .toList() ??
        [];

    return Post(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      text: json['text'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likes: List<String>.from(json['likes'] ?? []),
      comments: comments,
      isLiked: json['isLiked'] ?? false,
      isDisliked: json['isDisliked'] ?? false,
      isCommented: json['isCommented'] ?? false,
      isSaved: json['isSaved'] ?? false,
    );
  }
}
