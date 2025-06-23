import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_font_styles.dart';

class FollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;

  const FollowButton({
    super.key,
    required this.onPressed,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: MaterialButton(
        onPressed: onPressed,
        color: isFollowing ? Colors.white : AppColors.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          isFollowing ? "profile.unfollow".tr() : "profile.follow".tr(),
          style: AppFontStyles.poppins400_14.copyWith(
              color: isFollowing ? AppColors.primaryColor : Colors.white),
        ),
      ),
    );
  }
}
