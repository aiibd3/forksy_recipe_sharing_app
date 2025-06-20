import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/features/layout/presentation/widgets/my_drawer.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../posts/presentation/cubit/post_cubit.dart';
import '../../../posts/presentation/widgets/post_tile.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late final postCubit = context.read<PostCubit>();

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Tab"),
        backgroundColor: AppColors.primaryColor,
      ),
      drawer: MyDrawer(),
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
                child: ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 300),
                    Center(child: Text("No posts available")),
                  ],
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
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 300),
                  Center(child: Text("Press pull to load posts")),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
