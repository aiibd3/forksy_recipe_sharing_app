import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:forksy/core/extensions/context_extension.dart';
import '../../../../core/theme/app_colors.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    bool isEnglish = context.locale.languageCode == 'en';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLanguageButton(
          text: "drawer.english".tr(),
          isSelected: isEnglish,
          onTap: () {
            log("change language to en");
            context.setLocale(const Locale('en'));
            context.goBack();
          },
        ),
        const SizedBox(width: 10),
        _buildLanguageButton(
          text: "drawer.arabic".tr(),
          isSelected: !isEnglish,
          onTap: () {
            log("change language to ar");
            context.setLocale(const Locale('ar'));
            context.goBack();
          },
        ),
      ],
    );
  }

  Widget _buildLanguageButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondaryColor : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color:
                    isSelected ? Colors.transparent : AppColors.secondaryColor),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.secondaryColor,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
