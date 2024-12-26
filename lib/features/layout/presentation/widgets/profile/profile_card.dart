import 'dart:io';

import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../core/theme/app_colors.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;
  final VoidCallback onTap;

  const ProfileCard({
    super.key,
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 12.h,
        width: 100.w,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: _getImageWidget(imageUrl),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                EneftyIcons.user_edit_outline,
                color: AppColors.secondaryColor,
                size: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getImageWidget(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      if (Uri.tryParse(imageUrl)?.isAbsolute ?? false) {
        return Image.network(
          imageUrl,
          width: 75,
          height: 75,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _defaultImage(),
        );
      } else if (File(imageUrl).existsSync()) {
        return Image.file(
          File(imageUrl),
          width: 75,
          height: 75,
          fit: BoxFit.cover,
        );
      }
    }
    return _defaultImage();
  }

  Widget _defaultImage() {
    return Image.asset(
      'assets/images/default_avatar.png',
      width: 75,
      height: 75,
      fit: BoxFit.cover,
    );
  }
}
