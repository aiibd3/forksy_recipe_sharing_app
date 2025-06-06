import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timestamp;

  // final String postImage;
  // final String caption;
  // final String timeAgo;
  // final int likes;
  // final int comments;
  // final bool isLiked;



  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.imageUrl,
    required this.timestamp,
    // required this.postImage,
    // required this.caption,
    // required this.timeAgo,
    // required this.likes,
    // required this.comments,
    // required this.isLiked,
  });

  Post copyWith({String? imageUrl}) {
    return Post(
      id: id,
      userId: userId,
      userName: userName,
      text: text,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp,
      // postImage: postImage ?? this.postImage,
      // caption: caption ?? this.caption,
      // timeAgo: timeAgo ?? this.timeAgo,
      // likes: likes ?? this.likes,
      // comments: comments ?? this.comments,
      // isLiked: isLiked ?? this.isLiked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
      // 'postImage': postImage,
      // 'caption': caption,
      // 'timeAgo': timeAgo,
      // 'likes': likes,
      // 'comments': comments,
      // 'isLiked': isLiked,
    };
  }

  factory Post.fromMap(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      text: json['text'],
      imageUrl: json['imageUrl'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      // postImage: map['postImage'] as String,
      // caption: map['caption'] as String,
      // timeAgo: map['timeAgo'] as String,
      // likes: map['likes'] as int,
      // comments: map['comments'] as int,
      // isLiked: map['isLiked'] as bool,
    );
  }
}
