import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../posts/presentation/cubit/post_cubit.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  late final postCubit = context.read<PostCubit>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Tab"),
        backgroundColor: AppColors.primaryColor,
        actions: [
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              // Disable button during loading or when no posts are available
              final bool isLoading = state is PostLoading;
              final bool hasNoPosts = state is PostLoaded && state.posts.isEmpty;

              return IconButton(
                onPressed: isLoading || hasNoPosts
                    ? null // Disable button
                    : () {
                  context.read<PostCubit>().fetchAllPosts();
                },
                icon: const Icon(Icons.refresh),
                tooltip: isLoading
                    ? 'Loading posts...'
                    : hasNoPosts
                    ? 'No posts available'
                    : 'Refresh posts',
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            if (state.posts.isEmpty) {
              return const Center(child: Text("No posts available"));
            }
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(state.posts[index].text),
              ),
            );
          } else {
            return const Center(child: Text("Press refresh to load posts"));
          }
        },
      ),
    );
  }
}