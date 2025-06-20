import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/extensions/context_extension.dart';
import 'package:forksy/features/layout/presentation/widgets/my_drawer.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../../core/routing/routes_name.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../posts/presentation/cubit/post_cubit.dart';
import '../../../posts/presentation/widgets/post_tile.dart';

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

  Future<void> _initialize() async {
    if (authCubit.currentUser == null) {
      await authCubit.getCurrentUser();
    }
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  Future<void> refreshPosts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
    refreshPosts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          context.removeAllAndPush(RoutesName.auth);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home Tab"),
          backgroundColor: AppColors.primaryColor,
        ),
        drawer: const MyDrawer(),
        body: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostFailure) {
              return Center(child: Text(state.error));
            } else if (state is PostLoaded) {
              if (state.posts.isEmpty) {
                return LiquidPullToRefresh(
                  onRefresh: refreshPosts,
                  color: AppColors.primaryColor,
                  showChildOpacityTransition: false,
                  child: const Center(child: Text("No posts available")),
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
                child: const Center(child: Text("Press pull to load posts")),
              );
            }
          },
        ),
      ),
    );
  }
}
