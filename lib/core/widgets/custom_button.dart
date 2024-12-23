import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.color = AppColors.primaryColor,
    this.borderRadius = 15.0,
    this.contentPadding = 10,
    required this.label,
    required this.onPressed,
  });

  final Color color;
  final String label;
  final double borderRadius;
  final double contentPadding;

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(contentPadding),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
