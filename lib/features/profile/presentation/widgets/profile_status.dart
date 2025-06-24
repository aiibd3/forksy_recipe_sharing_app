import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/theme/app_colors.dart';

class ProfileStatus extends StatelessWidget {
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final void Function()? onTap;

  const ProfileStatus({
    super.key,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn(postsCount.toString(), "profile.posts".tr()),
          _buildStatColumn(followersCount.toString(), "profile.followers".tr()),
          _buildStatColumn(followingCount.toString(), "profile.following".tr()),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.grayColor,
          ),
        ),
      ],
    );
  }
}
