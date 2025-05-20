import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../theme/app_font_styles.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final bool isEditable;

  const ProfileTextField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.isEditable,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFontStyles.poppins400_14.copyWith(color: Colors.grey),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          initialValue: initialValue,
          enabled: isEditable,
          decoration: InputDecoration(
            filled: true,
            fillColor: isEditable ? Colors.white : Colors.grey.shade200,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isEditable ? AppColors.primaryColor : Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
          style: AppFontStyles.poppins400_16,
        ),
      ],
    );
  }
}
