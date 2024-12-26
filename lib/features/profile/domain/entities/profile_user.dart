import 'package:forksy/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String? bio;
  final String? profileImage;

  ProfileUser({
    required this.bio,
    required super.uid,
    required super.name,
    required super.email,
    required this.profileImage,
  });

  ProfileUser copyWith({
    String? bio,
    String? uid,
    String? name,
    String? email,
    String? profileImage,
  }) {
    return ProfileUser(
      bio: bio ?? this.bio,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'uid': uid,
      'name': name,
      'email': email,
      'profileImage': profileImage,
    };
  }

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      bio: json['bio'] ?? '',
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'].toString(),
    );
  }
}
