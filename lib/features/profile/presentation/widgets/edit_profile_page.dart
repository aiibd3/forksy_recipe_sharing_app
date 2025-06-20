import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/extensions/context_extension.dart';
import 'package:forksy/core/utils/logs_manager.dart';
import 'package:forksy/features/profile/domain/entities/profile_user.dart';
import 'package:forksy/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:forksy/features/profile/presentation/widgets/profile_avatar.dart';
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

    // if (bioController.text.isNotEmpty) {
    //   await profileCubit.updateProfileUser(
    //     uid: widget.user.uid,
    //     newBio: bioController.text,
    //   );
    // }


    // if (imageMobilePath == null && newBio == null) {
    //   LogsManager.error("No data to update.");
    //   throw Exception("No data provided for update.");
    // }




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

      }

      else {
        LogsManager.info("No changes detected.");
        context.goBack();
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
                  Text("Updating profile, please wait..."),
                ],
              ),
            ),
          );
        }
        else {
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
              Icons.save_alt_outlined,
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
            CachedNetworkImage(
              imageUrl: widget.user.profileImage ?? '',
              placeholder: (context, url) => const CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.person,
                color: AppColors.primaryColor,
                size: 50,
              ),
              imageBuilder: (context, imageProvider) => Image(
                image: imageProvider,
                width: 100.w,
                height: 30.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 2.h),

            ProfileAvatar(
              onTap: () async {
                await pickImage();
                setState(
                  () {},
                );
              },
              imageUrl: imagePickedFile != null
                  ? imagePickedFile!.path!
                  : widget.user.profileImage ?? "",
              name: widget.user.name,
              role: bioController.text.isNotEmpty
                  ? bioController.text
                  : "Enter your role",
            ),
            SizedBox(height: 2.h),

            // Bio Section
            const Text(
              "Bio",
              style: TextStyle(
                color: AppColors.grayColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: bioController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your bio',
              ),
              maxLines: 3, // Allow multi-line bio
            ),
            SizedBox(height: 2.h),


            // Additional Spacer or Actions
            ElevatedButton(
              onPressed: () {
                // Implement bio update logic
                updateProfile();
              },
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
