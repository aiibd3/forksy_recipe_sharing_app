import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/theme/app_colors.dart';
import 'package:forksy/core/utils/logs_manager.dart';
import 'package:forksy/features/auth/domain/entities/app_user.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/widgets/custom_text_field.dart';
import '../../../auth/data/repos/auth_repo.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../data/repos/profile_repo.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/profile_avatar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
          profileRepo: FirebaseProfileRepo(), authRepo: FirebaseAuthRepo()),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return const _ProfilePageBody();
        },
      ),
    );
  }
}

class _ProfilePageBody extends StatefulWidget {
  const _ProfilePageBody();

  @override
  State<_ProfilePageBody> createState() => _ProfilePageBodyState();
}

class _ProfilePageBodyState extends State<_ProfilePageBody> {
  // * cubit Auth & cubit Profile
  late final AuthCubit mainCubit = context.read<AuthCubit>();
  late final ProfileCubit profileCubit = context.read<ProfileCubit>();

  // * current user
  late AppUser? currentUser = mainCubit.currentUser;

  @override
  void initState() {
    super.initState();
    profileCubit.fetchProfileUser(currentUser!.uid);

    LogsManager.debug("Current user: $currentUser");
    if (currentUser == null) {
      debugPrint("No current user found.");
    }
  }

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
      body: currentUser == null
          ? Center(
              child: Text(
                'No user data available.',
                style: TextStyle(fontSize: 16.sp, color: AppColors.blackColor),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        ProfileAvatar(
                          name: currentUser!.email, // Safe to use `!` here
                          role: 'Edit Profile',
                          imageUrl: 'assets/images/hamoud.jpg',
                        ),
                        SizedBox(height: 4.h),
                        ProfileTextField(
                          label: 'Full name',
                          initialValue:
                              currentUser!.name, // Safe to use `!` here
                          isEditable: true,
                        ),
                        SizedBox(height: 2.h),
                        ProfileTextField(
                          label: 'E-mail',
                          initialValue:
                              currentUser!.email, // Safe to use `!` here
                          isEditable: false,
                        ),
                        SizedBox(height: 2.h),
                        const ProfileTextField(
                          label: 'Phone Number',
                          initialValue:
                              '01557399158', // Replace with actual data
                          isEditable: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
