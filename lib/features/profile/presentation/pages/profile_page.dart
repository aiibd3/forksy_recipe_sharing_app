import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/extensions/widget_extension.dart';
import 'package:forksy/core/theme/app_colors.dart';
import 'package:forksy/features/auth/domain/entities/app_user.dart';
import 'package:forksy/features/posts/presentation/cubit/post_cubit.dart';
import 'package:forksy/features/posts/presentation/widgets/post_tile.dart';
import 'package:forksy/features/profile/presentation/widgets/follow_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../posts/domain/entities/post.dart';
import '../widgets/edit_profile_page.dart';
import '../widgets/profile_avatar.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/bio_box.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  final Post? post;

  const ProfilePage({super.key, required this.uid, this.post});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();
  late AppUser? currentUser = authCubit.currentUser;

  int postsCount = 0;

  @override
  void initState() {
    super.initState();
    profileCubit.fetchProfileUser(widget.uid);
  }

  void followButtonPressed() {
    final state = profileCubit.state;

    if (state is! ProfileLoaded || currentUser == null) return;

    final profileUser = state.user;
    final isFollowing = profileUser.followers!.contains(currentUser!.uid);

    setState(() {
      if (isFollowing) {
        profileUser.followers!.remove(currentUser!.uid);
      } else {
        profileUser.followers!.add(currentUser!.uid);
      }
    });

    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((e) {
      setState(() {
        if (isFollowing) {
          profileUser.followers!.add(currentUser!.uid);
        } else {
          profileUser.followers!.remove(currentUser!.uid);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
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
          final bool canEdit = currentUser!.uid == profileUser.uid;

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
                if (canEdit)
                  IconButton(
                    icon: const Icon(
                      EneftyIcons.setting_2_outline,
                      color: AppColors.blackColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: profileCubit,
                            child: EditProfilePage(user: profileUser),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
            body: ListView(
              children: [
                Column(
                  children: [
                    ProfileAvatar(
                      onTap: () {
                        if (canEdit) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: profileCubit,
                                child: EditProfilePage(user: profileUser),
                              ),
                            ),
                          );
                        }
                      },
                      // name: profileUser.name,
                      imageUrl: profileUser.profileImage?.isNotEmpty == true
                          ? profileUser.profileImage!
                          : 'assets/images/user2.png',
                    ),
                    BlocBuilder<PostCubit, PostState>(
                      builder: (context, postState) {
                        if (postState is PostLoaded) {
                          postsCount = postState.posts
                              .where((post) => post.userId == widget.uid)
                              .length;
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatColumn(postsCount, "profile.posts".tr()),
                            _buildStatColumn(profileUser.followers?.length ?? 0,
                                "profile.followers".tr()),
                            _buildStatColumn(profileUser.following?.length ?? 0,
                                "profile.following".tr()),
                          ],
                        );
                      },
                    ),
                    // SizedBox(height: 2.h),
                    if (!canEdit)
                      FollowButton(
                        onPressed: followButtonPressed,
                        isFollowing:
                            profileUser.followers!.contains(currentUser!.uid),
                      ),
                    SizedBox(height: 2.h),
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
                    SizedBox(height: 2.h),
                  ],
                ).setPageHorizontalPadding(),
                BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    if (state is PostLoaded) {
                      final userPosts = state.posts
                          .where((post) => post.userId == widget.uid)
                          .toList();

                      postsCount = userPosts.length;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: postsCount,
                        itemBuilder: (context, index) {
                          final post = userPosts[index];

                          return PostTile(
                            post: post,
                            onDeletePressed: () =>
                                context.read<PostCubit>().deletePost(post.id),
                          );
                        },
                      );
                    } else if (state is PostLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          "profile.noPosts".tr(),
                          style: TextStyle(
                              fontSize: 16.sp, color: AppColors.blackColor),
                        ),
                      );
                    }
                  },
                ),
              ],
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

  Widget _buildStatColumn(int count, String label) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.grayColor,
          ),
        ),
      ],
    );
  }
}
