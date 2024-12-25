import 'package:forksy/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String? profileImage;

  ProfileUser({
    required super.uid,
    required super.name,
    required super.email,
    required this.profileImage,
  });

  ProfileUser copyWith({
    String? uid,
    String? name,
    String? email,
    String? profileImage,
  }) {
    return ProfileUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImage': profileImage,
    };
  }

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
    );
  }
}
