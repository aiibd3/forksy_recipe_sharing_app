import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocBuilder<AuthCubit,
          AuthState>(
        builder: (context, state) {
          return const _AuthPageBody();
        },
      ),
    );
  }
}
class _AuthPageBody extends StatelessWidget {
  const _AuthPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

