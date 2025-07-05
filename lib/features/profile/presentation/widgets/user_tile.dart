import 'package:flutter/material.dart';
import 'package:forksy/features/profile/domain/entities/profile_user.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/theme/app_colors.dart';
import '../pages/profile_page.dart';
import '../widgets/profile_avatar.dart';

class UserTile extends StatelessWidget {
  final ProfileUser user;

  const UserTile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      subtitleTextStyle: const TextStyle(
        fontSize: 12,
        color: Colors.black54,
      ),
      leading: SizedBox(
        width: 10.w,
        height: 5.h,
        child: ProfileAvatar(
          imageUrl: user.profileImage?.isNotEmpty == true
              ? user.profileImage!
              : 'assets/images/user.png',
          // role: user.bio, // Pass role if available in ProfileUser
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.primaryColor,
      ),
      onTap: () => Navigator.push(

        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            uid: user.uid,
          ),
        ),
      ),
    );
  }
}
