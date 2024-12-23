import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_font_styles.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;

  const ProfileAvatar({
    super.key,
    required this.name,
    required this.role,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 35.sp,
              backgroundImage: AssetImage(imageUrl),
            ),
            CircleAvatar(
              radius: 15.sp,
              backgroundColor: AppColors.primaryColor,
              child: Icon(
                Icons.camera_alt,
                color: AppColors.whiteColor,
                size: 18.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          name,
          style: AppFontStyles.poppins600_18,
        ),
        Text(
          role,
          style:
              AppFontStyles.poppins400_14.copyWith(color: AppColors.grayColor),
        ),
      ],
    );
  }
}
