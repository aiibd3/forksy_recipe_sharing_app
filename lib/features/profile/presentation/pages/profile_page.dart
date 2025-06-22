import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/theme/app_colors.dart';
import 'package:forksy/features/auth/domain/entities/app_user.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../storage/data/repos/firebase_storage_repo.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/repos/profile_repo.dart';
import '../widgets/edit_profile_page.dart';
import '../widgets/profile_avatar.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/bio_box.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  late AppUser? currentUser = authCubit.currentUser;

  @override
  void initState() {
    super.initState();
    profileCubit.fetchProfileUser(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    if (authCubit.currentUser == null) {
      return Scaffold(
        body: Center(
          child: Text("profile.noUser".tr()),
        ),
      );
    }

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          final profileUser = state.user;

          return Scaffold(
            backgroundColor: AppColors.whiteColor,
            appBar: AppBar(
              title: Text(
                profileUser.name,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => ProfileCubit(
                            storageRepo: FirebaseStorageRepo(),
                            profileRepo: FirebaseProfileRepo(),
                          ),
                          child: EditProfilePage(user: profileUser),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Stack(
                children: [
                  Column(
                    children: [
                      ProfileAvatar(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => ProfileCubit(
                                  storageRepo: FirebaseStorageRepo(),
                                  profileRepo: FirebaseProfileRepo(),
                                ),
                                child: EditProfilePage(user: profileUser),
                              ),
                            ),
                          );
                        },
                        name: profileUser.name,
                        role: "profile.edit".tr(),
                        imageUrl: profileUser.profileImage != null &&
                                profileUser.profileImage!.isNotEmpty
                            ? profileUser.profileImage!
                            : 'assets/images/user2.png',
                      ),
                      SizedBox(height: 4.h),
                      Text("profile.bioLabel".tr()),
                      BioBox(
                        text: profileUser.bio ?? "profile.noBio".tr(),
                      ),
                      SizedBox(height: 2.h),
                      ProfileTextField(
                        label: "profile.fullName".tr(),
                        initialValue: profileUser.name,
                        isEditable: false,
                      ),
                      SizedBox(height: 2.h),
                      ProfileTextField(
                        label: "profile.email".tr(),
                        initialValue: profileUser.email,
                        isEditable: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Text(
                "profile.noData".tr(),
                style: TextStyle(fontSize: 16.sp, color: AppColors.blackColor),
              ),
            ),
          );
        }
      },
    );
  }
}
