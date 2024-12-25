// import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_font_styles.dart';

class SettingsListItem extends StatelessWidget {
  final Function() onTap;
  final String title;
  final IconData icon;

  const SettingsListItem({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.h,
      child: Card(
        color: AppColors.whiteColor,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primaryColor,
                ),
                SizedBox(
                  width: 4.w,
                ),
                Text(
                  title,
                  style: AppFontStyles.poppins400_16,
                ),
                // const Spacer(),
                // Directionality(
                //   textDirection: TextDirection.ltr,
                //   child: Icon(
                //     context.locale.languageCode == "en"
                //         ? Icons.arrow_forward_ios
                //         : Icons.arrow_back_ios,
                //     color: AppColors.secondaryColor,
                //     size: 20,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
