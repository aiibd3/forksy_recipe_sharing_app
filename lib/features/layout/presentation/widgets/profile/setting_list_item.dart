// import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primaryColor,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: AppFontStyles.poppins400_16,
            ),
            const Spacer(),
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
    );
  }
}
