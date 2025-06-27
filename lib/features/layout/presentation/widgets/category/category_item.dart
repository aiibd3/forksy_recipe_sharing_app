import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_font_styles.dart';
import '../../../domain/entities/category_entities.dart';

class CategoryItem extends StatelessWidget {
  final CategoryEntity category;
  final bool isActive;

  const CategoryItem({
    super.key,
    required this.category,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isActive ? 20.w : 16.w,
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: isActive
            ? LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.blueColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [Colors.grey[100]!, Colors.grey[200]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 2,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: isActive ? 1 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: ClipOval(
              child: category.id == 'all'
                  ? Icon(
                      Icons.apps,
                      size: 30.sp,
                      color:
                          isActive ? AppColors.whiteColor : AppColors.grayColor,
                    )
                  : AnimatedRotation(
                      turns: isActive ? 2 : 0,
                      duration: const Duration(milliseconds: 500),
                      child: Image.asset(
                        category.imageUrl,
                        fit: BoxFit.cover,
                        width: 35.sp,
                        height: 35.sp,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),
                    ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "posts.${category.title}".tr(),
            style: AppFontStyles.poppins500_16.copyWith(
              color: isActive ? AppColors.whiteColor : AppColors.grayColor,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
