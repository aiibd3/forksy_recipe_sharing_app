import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/theme/app_colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/theme/app_font_styles.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/profile_avatar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return const _ProfilePageBody();
        },
      ),
    );
  }
}

class _ProfilePageBody extends StatelessWidget {
  const _ProfilePageBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: AppColors.blackColor),
        ),
        centerTitle: true,
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Stack(
            children: [
              Column(
                children: [
                  const ProfileAvatar(
                    name: 'AbdulRahman Hamoud',
                    role: 'Edit Profile',
                    imageUrl: 'assets/images/hamoud.jpg',
                  ),
                  SizedBox(height: 4.h),
                  const ProfileTextField(
                    label: 'Full name',
                    initialValue: 'AbdulRahman Hamoud',
                    isEditable: true,
                  ),
                  SizedBox(height: 2.h),
                  const ProfileTextField(
                    label: 'E-mail',
                    initialValue: 'a.hamoud@gmail.com',
                    isEditable: false,
                  ),
                  SizedBox(height: 2.h),
                  const ProfileTextField(
                    label: 'Phone Number',
                    initialValue: '01557399158',
                    isEditable: false,
                  ),
                  SizedBox(height: 16.h),
                  buildLogoutButton(context),
                  SizedBox(height: 4.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildLogoutButton(BuildContext context) {
  return Align(
    // alignment: context.locale.languageCode == 'ar'
    //     ? Alignment.centerRight
    //     : Alignment.centerLeft,
    alignment:  Alignment.centerLeft,
    child: GestureDetector(
      onTap: () {
        log("User logged out");
        // todo -> Navigate to the login screen or perform logout logic
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
