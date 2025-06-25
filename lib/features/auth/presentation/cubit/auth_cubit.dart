import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/errors/firebase_error_handler.dart';
import 'package:forksy/core/utils/logs_manager.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repos/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AppUser? _currentUser;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  static AuthCubit get(BuildContext context) =>
      BlocProvider.of<AuthCubit>(context);

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  Future<void> logout() async {
    await authRepo.logout();
    emit(UnAuthenticated());
  }

  Future<void> checkUserIsLogged() async {
    final user = await authRepo.getCurrentUser();
    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(UnAuthenticated());
    }
  }

  AppUser? get currentUser => _currentUser;

  Future<void> login(String email, String password) async {
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

  Future<void> register(String name, String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.registerWithEmailPassword(name, email, password);
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

  Future<void> getCurrentUser() async {
    final user = await authRepo.getCurrentUser();
    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(UnAuthenticated());
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}