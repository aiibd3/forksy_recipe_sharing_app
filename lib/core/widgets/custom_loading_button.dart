import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../theme/app_colors.dart';

class CustomLoadingButton extends StatefulWidget {
  final String title;
  final Function onPressed;
  final double width;

  const CustomLoadingButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.width = 80,
  });

  @override
  State<CustomLoadingButton> createState() => _CustomLoadingButtonState();
}

class _CustomLoadingButtonState extends State<CustomLoadingButton> {
  @override
  Widget build(BuildContext context) {
    return EasyButton(
      idleStateWidget: Text(
        widget.title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      loadingStateWidget: const CircularProgressIndicator(
        strokeWidth: 3.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.white,
        ),
      ),
      useWidthAnimation: true,
      useEqualLoadingStateWidgetDimension: true,
      borderRadius: 25,
      width: widget.width.w,
      height: 5.h,
      contentGap: 6.0,
      buttonColor: AppColors.primaryColor,
      onPressed: onButtonPressed,
    );
  }

  onButtonPressed() async {
    await widget.onPressed();
  }
}
