import 'dart:developer';

import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/extensions/context_extension.dart';
import 'package:forksy/core/extensions/widget_extension.dart';
import 'package:forksy/core/routing/routes_name.dart';
import 'package:forksy/features/layout/presentation/widgets/profile/setting_list_item.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_font_styles.dart';
import '../../cubit/layout_cubit.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit(),
      child: BlocBuilder<LayoutCubit, LayoutState>(
        builder: (context, state) {
          return Container(
            constraints: BoxConstraints(maxHeight: 80.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SettingsListItem(
                    onTap: () {
                      // Handle language change
                    },
                    title: "Language",
                    icon: EneftyIcons.language_square_outline,
                  ),
                  SizedBox(height: 1.h),
                  const Divider(
                    height: 1,
                    thickness: 0.5,
                    color: AppColors.secondaryColor,
                  ),
                  SizedBox(height: 1.h),
                  SettingsListItem(
                    onTap: () {},
                    title: "Likes",
                    icon: EneftyIcons.lovely_outline,
                  ),
                  SizedBox(height: 1.h),
                  const Divider(
                    height: 1,
                    thickness: 0.5,
                    color: AppColors.secondaryColor,
                  ),
                  SizedBox(height: 1.h),
                  SettingsListItem(
                    onTap: () {},
                    title: "Saves",
                    icon: EneftyIcons.save_2_outline,
                  ),
                  SizedBox(height: 1.h),
                  const Divider(
                    height: 1,
                    thickness: 0.5,
                    color: AppColors.secondaryColor,
                  ),
                  SizedBox(height: 1.h),
                  SettingsListItem(
                    onTap: () {},
                    title: "Privacy",
                    icon: EneftyIcons.text_block_outline,
                  ),
                  SizedBox(height: 10.h),
                  buildLogoutButton(context),
                  SizedBox(height: 1.h),
                ],
              ).setPageHorizontalPadding(),
            ),
          );
        },
      ),
    );
  }
}

Widget buildLogoutButton(BuildContext context) {
  return Align(
    // alignment: context.locale.languageCode == 'ar'
    //     ? Alignment.centerRight
    //     : Alignment.centerLeft,
    alignment: Alignment.centerLeft,
    child: GestureDetector(
      onTap: () {
        log("User logged out");
        // todo -> Navigate to the login screen or perform logout logic
        context.removeAllAndPush(RoutesName.layout, arguments: RoutesName.auth);
        // context.goBackUntil(RoutesName.auth);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.sp),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(50),
        ),
        height: 6.h,
        // width: context.locale.languageCode == 'ar' ? 37.w : 34.w,
        width: 34.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 15.sp,
              backgroundColor: AppColors.whiteColor,
              child: Icon(
                Icons.power_settings_new,
                size: 20.sp,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Logout",
              style: AppFontStyles.poppins500_16.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
