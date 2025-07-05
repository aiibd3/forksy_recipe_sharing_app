import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_font_styles.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../posts/presentation/widgets/comment_tile.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../cubit/postDetails_cubit.dart';

class PostDetailsPage extends StatelessWidget {
  final String postId;

  const PostDetailsPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostDetailsCubit()..fetchPostDetails(postId),
      child: BlocBuilder<PostDetailsCubit, PostDetailsState>(
        builder: (context, state) {
          if (state is PostDetailsLoading) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            );
          } else if (state is PostDetailsLoadedSuccess) {
            final post = state.post;
            final postUser = state.postUser;
            final isOwner =
                context.read<AuthCubit>().currentUser?.uid == post.userId;

            return Scaffold(
              body: Stack(
                children: [
                  // Post Image
                  CachedNetworkImage(
                    imageUrl: post.imageUrl,
                    height: 65.h,
                    width: 100.w,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 30.h,
                      color: Colors.grey[200],
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/placeholder.jpg',
                      height: 30.h,
                      width: 100.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Content Area
                  CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          margin: EdgeInsets.only(top: 60.h),
                          decoration: const BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 2.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 18.w,
                                    height: 0.6.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                // User Info
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfilePage(uid: post.userId),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      postUser?.profileImage != null
                                          ? CachedNetworkImage(
                                              imageUrl: postUser!.profileImage!,
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
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
                                              backgroundImage: AssetImage(
                                                  'assets/images/user2.png'),
                                            ),
                                      SizedBox(width: 2.w),
                                      Expanded(
                                        child: Text(
                                          post.userName,
                                          style: AppFontStyles.poppins500_16,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                // Post Title and Timestamp
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        post.text,
                                        style: AppFontStyles.poppins500_20,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      DateFormat('yyyy-MM-dd')
                                          .format(post.timestamp),
                                      style: AppFontStyles.poppins400_16
                                          .copyWith(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  post.text,
                                  style: AppFontStyles.poppins400_14,
                                ),
                                SizedBox(height: 2.h),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => context
                                          .read<PostDetailsCubit>()
                                          .toggleLikePost(post.id, context),
                                      child: Row(
                                        children: [
                                          Icon(
                                            post.likes.contains(context
                                                    .read<AuthCubit>()
                                                    .currentUser
                                                    ?.uid)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: post.likes.contains(context
                                                    .read<AuthCubit>()
                                                    .currentUser
                                                    ?.uid)
                                                ? Colors.red
                                                : AppColors.grayColor,
                                          ),
                                          SizedBox(width: 1.w),
                                          Text(
                                            post.likes.length.toString(),
                                            style: AppFontStyles.poppins400_16,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    GestureDetector(
                                      onTap: () => context
                                          .read<PostDetailsCubit>()
                                          .openNewComment(context, post.id),
                                      child: Row(
                                        children: [
                                          Icon(Icons.comment_outlined,
                                              color: AppColors.grayColor),
                                          SizedBox(width: 1.w),
                                          Text(
                                            post.comments.length.toString(),
                                            style: AppFontStyles.poppins400_16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                // Comments Section
                                if (post.comments.isEmpty)
                                  Center(
                                    child: Text(
                                      "posts.noComments".tr(),
                                      style: AppFontStyles.poppins400_16,
                                    ),
                                  )
                                else
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: post.comments.length,
                                    itemBuilder: (context, index) {
                                      return CommentTile(
                                          comment: post.comments[index]);
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Close Button
                  Positioned(
                    top: 4.h,
                    left: 2.w,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close,
                            color: AppColors.blackColor),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4.h,
                    right: 2.w,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          post.likes.contains(
                                  context.read<AuthCubit>().currentUser?.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: post.likes.contains(
                                  context.read<AuthCubit>().currentUser?.uid)
                              ? Colors.red
                              : AppColors.secondaryColor,
                        ),
                        onPressed: () => context
                            .read<PostDetailsCubit>()
                            .toggleLikePost(post.id, context),
                      ),
                    ),
                  ),
                  if (isOwner)
                    Positioned(
                      top: 12.h,
                      right: 2.w,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete,
                              color: AppColors.grayColor),
                          onPressed: () => context
                              .read<PostDetailsCubit>()
                              .deletePost(post.id, context),
                        ),
                      ),
                    ),
                ],
              ),
            );
          } else if (state is PostDetailsLoadedFailure) {
            return Scaffold(
              body: Center(
                child: Text(
                  "${"posts.fetchError".tr()}: ${state.error}",
                  style: AppFontStyles.poppins400_16,
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: Text(
                "posts.refreshPrompt".tr(),
                style: AppFontStyles.poppins400_16,
              ),
            ),
          );
        },
      ),
    );
  }
}
