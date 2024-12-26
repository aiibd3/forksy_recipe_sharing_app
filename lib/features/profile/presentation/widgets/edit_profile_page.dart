import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/extensions/context_extension.dart';
import 'package:forksy/core/extensions/widget_extension.dart';
import 'package:forksy/features/profile/domain/entities/profile_user.dart';
import 'package:forksy/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/theme/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final bioController = TextEditingController();

  // PlatformFile? profileImage;



  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();

    if (bioController.text.isNotEmpty) {
      await profileCubit.updateProfileUser(
        uid: widget.user.uid,
        newBio: bioController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Loading..."),
                ],
              ),
            ),
          );
        } else {
          return buildBioBox();
        }
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          context.goBack();
        }
      },
    );
  }

  Widget buildBioBox() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: AppColors.grayColor),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.grayColor,
          ),
          onPressed: () {
            context.goBack();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.upload,
              color: AppColors.primaryColor,
              size: 20.sp,
            ),
            onPressed: updateProfile,
          )
        ],
      ),
      body: Column(
        children: [
          const Text("bio",
              style: TextStyle(
                  color: AppColors.grayColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 2.h),
          TextField(
            controller: bioController,
            obscureText: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your bio',
            ),
          ),
        ],
      ).setPageHorizontalPadding(),
    );
  }
}
