import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../posts/presentation/cubit/post_cubit.dart';
import '../../../posts/presentation/widgets/post_tile.dart';
import '../widgets/category/category_page.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/my_drawer.dart';

/// A widget that displays the home tab with a list of posts and category filters.
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late final postCubit = context.read<PostCubit>();
  late final authCubit = context.read<AuthCubit>();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  /// Initializes the cubits and fetches posts.
  Future<void> _initialize() async {
    if (authCubit.currentUser == null) {
      await authCubit.getCurrentUser();
    }
    fetchAllPosts();
  }

  /// Fetches all posts from the PostCubit.
  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  /// Refreshes the list of posts.
  Future<void> refreshPosts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    postCubit.fetchAllPosts();
  }

  /// Deletes a post and refreshes the list.
  void deletePost(String postId) {
    postCubit.deletePost(postId);
    refreshPosts();
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          context.removeAllAndPush('/auth');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'homeTab.title'.tr(),
            style: TextStyle(fontSize: 20.sp),
          ),
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          centerTitle: true,
        ),
        drawer: const MyDrawer(),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, Colors.blue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              CategoryPage(
                onShowAll: fetchAllPosts,
              ),
              Expanded(
                child: BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    if (state is PostLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    } else if (state is PostFailure) {
                      return Center(
                        child: Text(
                          "${'posts.fetchError'.tr()}: ${state.error}",
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      );
                    } else if (state is PostLoaded) {
                      if (state.posts.isEmpty) {
                        return LiquidPullToRefresh(
                          onRefresh: refreshPosts,
                          color: AppColors.primaryColor,
                          showChildOpacityTransition: false,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'assets/lottie/emtpy.json',
                                  height: 20.h,
                                ),
                                Text(
                                  'homeTab.noPosts'.tr(),
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return LiquidPullToRefresh(
                        onRefresh: refreshPosts,
                        color: AppColors.primaryColor,
                        showChildOpacityTransition: false,
                        child: ListView.builder(
                          itemCount: state.posts.length,
                          itemBuilder: (context, index) {
                            final post = state.posts[index];
                            return PostTile(
                              post: post,
                              onDeletePressed: () => deletePost(post.id),
                            );
                          },
                        ),
                      );
                    } else {
                      return LiquidPullToRefresh(
                        onRefresh: refreshPosts,
                        color: AppColors.primaryColor,
                        showChildOpacityTransition: false,
                        child: Center(
                          child: Text(
                            'homeTab.pullToLoad'.tr(),
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
