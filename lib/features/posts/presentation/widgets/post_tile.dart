import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../profile/domain/entities/profile_user.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../../core/theme/app_font_styles.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';
import '../cubit/post_cubit.dart';
import 'comment_tile.dart';

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
    isOwnerPost = (currentUser?.uid == widget.post.userId);
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

  final commentController = TextEditingController();

  void openNewComment() {
    if (currentUser == null) {
      debugPrint('⚠️ currentUser is null. Cannot add comment.');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          content: TextField(
            controller: commentController,
            obscureText: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "posts.delete".tr(),
              ),
            ),
            TextButton(
              onPressed: () {
                addComment();
                Navigator.pop(context);
              },
              child: Text("comments.save".tr()),
            ),
          ]),
    );
  }

  void addComment() {
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: commentController.text,
      timesTamp: DateTime.now(),
    );

    if (commentController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
      commentController.clear();
      debugPrint('⚠️ currentUser is null. Cannot add comment.');
    }
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("posts.deletePost".tr()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("posts.cancel".tr()),
          ),
          TextButton(
              onPressed: () {
                widget.onDeletePressed!();
                Navigator.pop(context);
              },
              child: Text(
                "posts.delete".tr(),
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    commentController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  uid: widget.post.userId,
                ),
              ),
            ),
            child: Padding(
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
                          backgroundImage:
                              AssetImage('assets/images/user2.png'),
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
                  if (isOwnerPost)
                    GestureDetector(
                      onTap: showOptions,
                      child:
                          const Icon(Icons.delete, color: AppColors.grayColor),
                    )
                ],
              ),
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
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: Icon(
                          widget.post.likes.contains(currentUser?.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.post.likes.contains(currentUser?.uid)
                              ? Colors.red
                              : AppColors.grayColor,
                        ),
                      ),
                      Text(
                        widget.post.likes.length.toString(),
                        style: AppFontStyles.poppins400_16,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                    onTap: openNewComment,
                    child: Icon(
                      Icons.comment_outlined,
                      color: AppColors.grayColor,
                    )),
                SizedBox(width: 2.w),
                Text(
                  widget.post.comments.length.toString(),
                  style: AppFontStyles.poppins400_16,
                ),
                Spacer(),
                Text(
                  DateFormat('yyyy-MM-dd').format(widget.post.timestamp),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              children: [
                Text(
                  widget.post.userName,
                  style: AppFontStyles.poppins400_16,
                ),
                SizedBox(width: 2.w),
                Text(
                  widget.post.text,
                  style: AppFontStyles.poppins400_16,
                ),
              ],
            ),
          ),
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              if (state is PostLoaded) {
                final post =
                    state.posts.firstWhere((post) => post.id == widget.post.id);

                if (post.comments.isEmpty) {
                  return Center(
                    child: Text(
                      "posts.noComments".tr(),
                    ),
                  );
                }

                if (post.comments.isNotEmpty) {
                  int showCommentsCount = post.comments.length;

                  return ListView.builder(
                      itemCount: showCommentsCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final comment = post.comments[index];
                        return CommentTile(
                          comment: comment,
                        );
                      });
                }
              } else if (state is PostLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PostFailure) {
                return Center(child: Text(state.error));
              } else {
                return Center(
                  child: Text(
                    "posts.refreshPrompt".tr(),
                  ),
                );
              }
              return Center(
                child: Text(
                  "posts.refreshPrompt".tr(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
