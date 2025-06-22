import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/extensions/context_extension.dart';
import 'package:forksy/core/utils/logs_manager.dart';
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

  PlatformFile? imagePickedFile;

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
      });
    }
  }

  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();
    final String uid = widget.user.uid;
    final imageMobilePath = imagePickedFile?.path;
    final String? newBio =
        bioController.text.isNotEmpty ? bioController.text : null;

    if (newBio != null || imagePickedFile != null) {
      profileCubit.updateProfileUser(
        uid: uid,
        newBio: newBio,
        imageProfilePath: imageMobilePath,
      );
    } else {
      LogsManager.info("No changes detected.");
      context.goBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Scaffold(
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
                  Text("editProfile.saving".tr()),
                ],
              ),
            ),
          );
        } else {
          return buildEditPage();
        }
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          context.goBack();
        }
      },
    );
  }

  Widget buildEditPage({double? uploadProgress = 0.0}) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "editProfile.title".tr(),
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
              Icons.done_rounded,
              color: AppColors.primaryColor,
              size: 20.sp,
            ),
            onPressed: updateProfile,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                await pickImage();
                setState(() {});
              },
              child: ClipOval(
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: imagePickedFile != null
                      ? Image.file(
                          File(imagePickedFile!.path!),
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.user.profileImage ?? '',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/default_avatar.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Bio Section
            Text(
              "editProfile.bio".tr(),
              style: TextStyle(
                color: AppColors.grayColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: bioController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "editProfile.enterBio".tr(),
              ),
            ),
            SizedBox(height: 2.h),

            ElevatedButton(
              onPressed: () {
                updateProfile();
              },
              child: Text("editProfile.saveChanges".tr()),
            ),
          ],
        ),
      ),
    );
  }
}
