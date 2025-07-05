import 'dart:io';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_font_styles.dart';

class ProfileAvatar extends StatelessWidget {
  final String? role;
  final String imageUrl;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.onTap,
    this.role,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40, // Default height to ensure it fits in most contexts
      child: Column(
        mainAxisSize: MainAxisSize.min, // Use minimum space needed
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 16.sp, // Reduced radius for smaller size, adjust as needed
                backgroundImage: _getImageProvider(imageUrl),
                backgroundColor: AppColors.grayColor.withOpacity(0.2),
                child: imageUrl.isEmpty
                    ? Icon(
                  Icons.person,
                  size: 20.sp, // Reduced icon size
                  color: AppColors.primaryColor,
                )
                    : null,
              ),
            ],
          ),
          if (role != null && role!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Text(
                role!,
                style: AppFontStyles.poppins400_14.copyWith(color: AppColors.grayColor),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis, // Prevent text overflow
                maxLines: 1,
              ),
            ),
        ],
      ),
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
    return const AssetImage('assets/images/sad_face.png');
  }
}