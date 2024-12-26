import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../post/presentation/cubit/post_cubit.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Tab"),
          backgroundColor: AppColors.primaryColor,
          // * add a back button
          actions: [
            IconButton(
              onPressed: () {
                context.read<PostCubit>().fetchAllPosts();
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: const Center(
          child: Text("Home Tab"),
        ));
  }
}
