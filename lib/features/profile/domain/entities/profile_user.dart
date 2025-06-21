import 'package:forksy/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String? bio;
  final String? profileImage;

  ProfileUser({
    required super.uid,
    required super.email,
    required super.name,
    required this.bio,
    required this.profileImage,
  });

  ProfileUser copyWith({
    String? newBio,
    String? newProfileImageURL,
  }) {
    return ProfileUser(
      uid: uid,
      email: email,
      name: name,
      bio: newBio ?? bio,
      profileImage: newProfileImageURL ?? profileImage,
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
    );
  }
}
