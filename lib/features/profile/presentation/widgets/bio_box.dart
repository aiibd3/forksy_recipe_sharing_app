import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_font_styles.dart';

class BioBox extends StatelessWidget {
  final String bio;

  const BioBox({
    super.key,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      width: 100.w,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        bio.isNotEmpty ? bio : 'No bio yet... :(',
        style:
            AppFontStyles.poppins400_14.copyWith(color: AppColors.whiteColor),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
