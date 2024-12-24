import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/features/auth/domain/repos/auth_repo.dart';

import '../../../../core/errors/firebase_error_handler.dart';
import '../../../../core/utils/logs_manager.dart';
import '../../domain/entities/app_user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AppUser? _currentUser;
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  static AuthCubit get(BuildContext context) =>
      BlocProvider.of<AuthCubit>(context);

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  // * check if user is logged in
  Future<void> checkUserIsLogged() async {
    final user = await authRepo.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(UnAuthenticated());
    }
  }

  // * get current user
  AppUser? get currentUser => _currentUser;

  // * login w email and password
  Future<void> login(String email, String password) async {
    // ? validate
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailPassword(email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } on FirebaseException catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
    }
  }

  // * register w email and password
  Future<void> register(String name, String email, String password) async {
    try {
      emit(AuthLoading());
      final user =
          await authRepo.registerWithEmailPassword(name, email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } on FirebaseException catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
    }
  }

  // * logout
  Future<void> logout() async {
    await authRepo.logout();
    emit(UnAuthenticated());
  }
}
