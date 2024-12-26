import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/storage_cubit.dart';
class StoragePage extends StatelessWidget {
  const StoragePage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StorageCubit(),
      child: BlocBuilder<StorageCubit,
          StorageState>(
        builder: (context, state) {
          return const _StoragePageBody();
        },
      ),
    );
  }
}
class _StoragePageBody extends StatelessWidget {
  const _StoragePageBody();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

