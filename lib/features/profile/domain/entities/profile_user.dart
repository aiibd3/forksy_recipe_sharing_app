import 'package:forksy/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String? bio;
  final String? profileImage;
  final List<String>? followers;
  final List<String>? following;

  ProfileUser({
    required super.uid,
    required super.email,
    required super.name,
    required this.bio,
    required this.profileImage,
    required this.followers,
    required this.following,
  });

  ProfileUser copyWith({
    String? newBio,
    String? newProfileImageURL,
    List<String>? newFollowers,
    List<String>? newFollowing,
  }) {
    return ProfileUser(
      uid: uid,
      email: email,
      name: name,
      bio: newBio ?? bio,
      profileImage: newProfileImageURL ?? profileImage,
      followers: newFollowers ?? followers,
      following: newFollowing ?? following,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'uid': uid,
      'name': name,
      'email': email,
      'profileImage': profileImage ?? '',
      'followers': followers ?? [],
      'following': following ?? [],
    };
  }

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      bio: json['bio'] ?? '',
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      profileImage: (json['profileImage'] != null &&
              json['profileImage'].toString() != 'null')
          ? json['profileImage'].toString()
          : null,
      followers: List<String>.from(json['followers'] ?? []),
      following: List<String>.from(json['following'] ?? []),
    );
  }
}
