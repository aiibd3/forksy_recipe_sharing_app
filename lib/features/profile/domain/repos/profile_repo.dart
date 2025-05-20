import '../entities/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> fetchProfileUser(String uid);
  Future<ProfileUser?> updateProfileUser(ProfileUser updatedUser);
}
