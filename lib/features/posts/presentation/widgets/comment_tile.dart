import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_font_styles.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/entities/comment.dart';
import '../cubit/post_cubit.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  AppUser? currentUser;
  bool isOwnerComment = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  /// Fetches the current user and checks if they are the comment owner.
  void getCurrentUser() {
    currentUser = context.read<AuthCubit>().currentUser;
    isOwnerComment = currentUser?.uid == widget.comment.userId;
  }

  /// Shows a dialog with options to delete the comment (if the user is the owner).
  void showOptions() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.whiteColor,
        title: Text('comments.deleteComment'.tr()),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.grayColor,
              backgroundColor: AppColors.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text('posts.cancel'.tr()),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.whiteColor,
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              context
                  .read<PostCubit>()
                  .deleteComment(widget.comment.postId, widget.comment.id);
              Navigator.pop(context);
            },
            child: Text('comments.deleteComment'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.comment.userName,
            style: AppFontStyles.poppins400_16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: ReadMoreText(
              widget.comment.text,
              trimLines: 1,
              colorClickableText: AppColors.blueColor,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'comments.readMore'.tr(),
              trimExpandedText: 'comments.readLess'.tr(),
              style: AppFontStyles.poppins400_16,
              moreStyle: AppFontStyles.poppins400_16.copyWith(
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.w600,
              ),
              lessStyle: AppFontStyles.poppins400_16.copyWith(
                color: AppColors.blueColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isOwnerComment)
            GestureDetector(
              onTap: showOptions,
              child: const Icon(
                Icons.more_horiz,
                color: AppColors.grayColor,
              ),
            ),
        ],
      ),
    );
  }
}
