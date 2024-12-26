import 'dart:io';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_font_styles.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;
  final VoidCallback onTap;

  const ProfileAvatar({
    super.key,
    required this.onTap,
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
              backgroundImage: _getImageProvider(imageUrl),
              backgroundColor: AppColors.grayColor.withOpacity(0.2),
              child: imageUrl.isEmpty
                  ? const Icon(
                Icons.person,
                size: 50,
                color: AppColors.primaryColor,
              )
                  : null,
            ),
            CircleAvatar(
              radius: 15.sp,
              backgroundColor: AppColors.primaryColor,
              child: GestureDetector(
                onTap: onTap,
                child: Icon(
                  Icons.camera_alt,
                  color: AppColors.whiteColor,
                  size: 18.sp,
                ),
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
          style: AppFontStyles.poppins400_14.copyWith(color: AppColors.grayColor),
        ),
      ],
    );
  }

  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      if (Uri.tryParse(imageUrl)?.isAbsolute ?? false) {
        return NetworkImage(imageUrl);
      } else if (File(imageUrl).existsSync()) {
        return FileImage(File(imageUrl));
      }
    }
    return const AssetImage('assets/images/default_avatar.png');
  }
}
