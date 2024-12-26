import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/theme/app_colors.dart';
// import 'package:forksy/core/utils/logs_manager.dart';
// import 'package:forksy/features/auth/domain/entities/app_user.dart';
// import 'package:forksy/features/profile/domain/entities/profile_user.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/widgets/custom_text_field.dart';
import '../../../auth/data/repos/auth_repo.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../storage/data/repos/firebase_storage_repo.dart';
import '../../data/repos/profile_repo.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/bio_box.dart';
import '../widgets/edit_profile_page.dart';
import '../widgets/profile_avatar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("No user logged in."),
        ),
      );
    }

    return BlocProvider(
      create: (context) => ProfileCubit(
        storageRepo: FirebaseStorageRepo(),
        profileRepo: FirebaseProfileRepo(),
        authRepo: FirebaseAuthRepo(),
      )..fetchProfileUser(user.uid),
      child: _ProfilePageBody(),
    );
  }
}

class _ProfilePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ),
          );
        } else if (state is ProfileLoaded) {
          final profileUser = state.user;
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
                icon: const Icon(Icons.arrow_back_ios,
                    color: AppColors.blackColor),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    EneftyIcons.setting_2_outline,
                    color: AppColors.blackColor,
                  ),
                  onPressed: () {
                    final profileUser =
                        state.user; // Assuming state.user is available
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => ProfileCubit(
                              storageRepo: FirebaseStorageRepo(),
                              authRepo: FirebaseAuthRepo(),
                              profileRepo: FirebaseProfileRepo()),
                          child: EditProfilePage(user: profileUser),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        ProfileAvatar(
                          name: profileUser.name,
                          role: 'Edit Profile',
                          imageUrl: 'assets/images/hamoud.jpg',
                        ),
                        SizedBox(height: 4.h),
                        BioBox(
                          bio: profileUser.bio ?? 'No bio yet... :(',
                        ),
                        SizedBox(height: 2.h),
                        ProfileTextField(
                          label: 'Full name',
                          initialValue: profileUser.name,
                          isEditable: true,
                        ),
                        SizedBox(height: 2.h),
                        ProfileTextField(
                          label: 'E-mail',
                          initialValue: profileUser.email,
                          isEditable: false,
                        ),
                        SizedBox(height: 2.h),
                        const ProfileTextField(
                          label: 'Phone Number',
                          initialValue: '01557399158',
                          isEditable: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Text(
                'No user data available.',
                style: TextStyle(fontSize: 16.sp, color: AppColors.blackColor),
              ),
            ),
          );
        }
      },
    );
  }
}
