import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/features/posts/data/repos/post_repo.dart';

import '../../../storage/data/repos/firebase_storage_repo.dart';
import '../cubit/post_cubit.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(
          postRepo: FirebasePostRepo(), storageRepo: FirebaseStorageRepo()),
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          return const _PostsPageBody();
        },
      ),
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
