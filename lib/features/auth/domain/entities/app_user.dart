class AppUser {
  final String uid;
  final String email;
  final String name;

  const AppUser({
    required this.email,
    required this.name,
    required this.uid,
  });

// * convert app user -> json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }

// * convert json -> app user
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
    );
  }
}