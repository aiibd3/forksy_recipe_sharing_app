import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../storage/data/repos/firebase_storage_repo.dart';
import '../../data/repos/post_repo.dart';
import '../cubit/post_cubit.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(
          postRepo: FirebasePostRepo(), storageRepo: FirebaseStorageRepo()),
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          return const _PostPageBody();
        },
      ),
    );
  }
}

class _PostPageBody extends StatelessWidget {
  const _PostPageBody({super.key});

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
