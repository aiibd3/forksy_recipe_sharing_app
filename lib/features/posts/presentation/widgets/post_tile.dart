import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_font_styles.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../profile/domain/entities/profile_user.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../domain/entities/post.dart';
import '../cubit/post_cubit.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const PostTile({super.key, required this.post, this.onDeletePressed});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isOwnerPost = false;
  AppUser? currentUser;
  ProfileUser? postUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();

    if (widget.post.userId.trim().isNotEmpty) {
      fetchPostUser();
    } else {
      postUser = null;
      debugPrint(
          '⚠️ Warning: post.userId is empty for post: ${widget.post.id}');
    }
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    // isOwnerPost = (currentUser?.uid == widget.post.userId);

    if (isOwnerPost) {
      isOwnerPost = (currentUser!.uid == widget.post.userId);
    } else {
      isOwnerPost = false;
    }
  }

  Future<void> fetchPostUser() async {
    final fetchUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchUser != null) {
      setState(() {
        postUser = fetchUser;
      });
    }
  }

  void toggleLikePost() {
    if (currentUser == null) {
      debugPrint('⚠️ currentUser is null. Cannot like post.');
      return;
    }

    final isLiked = widget.post.likes.contains(currentUser!.uid);

    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });

    postCubit.toggleLikePost(widget.post.id, currentUser!.uid).catchError((e) {
      debugPrint('⚠️ Error: $e');
      // Revert UI if error
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid);
        } else {
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete post?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              widget.onDeletePressed!();
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                postUser?.profileImage != null
                    ? CachedNetworkImage(
                        imageUrl: postUser!.profileImage ?? "",
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SizedBox(
                          height: 60,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/user2.png'),
                      ),
                SizedBox(width: 2.w),
                Text(
                  widget.post.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: showOptions,
                  child: const Icon(Icons.delete, color: AppColors.grayColor),
                )
              ],
            ),
          ),
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(
              height: 430,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: toggleLikePost,
                  child: Icon(
                    widget.post.likes.contains(currentUser?.uid)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: AppColors.grayColor,
                  ),
                ),
                Text(
                  widget.post.likes.length.toString(),
                  style: AppFontStyles.poppins400_16,
                ),
                const Spacer(),
                Icon(Icons.comment_outlined, color: AppColors.grayColor),
                Text(
                  "0 comments",
                  style: AppFontStyles.poppins400_16,
                ),
                Spacer(),
                Text(
                  widget.post.timestamp.toString(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
