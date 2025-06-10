import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/post_cubit.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        return const _PostsPageBody();
      },
    );
  }
}

class _PostsPageBody extends StatelessWidget {
  const _PostsPageBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<PostCubit>().fetchAllPosts();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
