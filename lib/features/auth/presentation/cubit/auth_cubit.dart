import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
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
    try {
      await authRepo.logout();
      _currentUser = null;
      emit(UnAuthenticated());
    } catch (e) {
      LogsManager.error("Logout failed: $e");
      emit(AuthError("auth.logoutFailed".tr()));
    }
  }

  Future<void> checkUserIsLogged() async {
    try {
      final user = await authRepo.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      LogsManager.error("Check user logged failed: $e");
      emit(AuthError("auth.checkUserFailed".tr()));
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
      LogsManager.error("Login error: ${e.code}");
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          emit(AuthInvalidCredentials());
          break;
        case 'invalid-email':
          emit(AuthInvalidEmail());
          break;
        case 'too-many-requests':
          emit(AuthTooManyRequests());
          break;
        default:
          final errorHandler = FirebaseErrorHandler.handleError(e);
          emit(AuthError(errorHandler.errorMessage));
      }
      emit(UnAuthenticated());
    } catch (e) {
      LogsManager.error("Unexpected login error: $e");
      emit(AuthError("auth.unexpectedError".tr()));
      emit(UnAuthenticated());
    }
  }

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
      LogsManager.error("Registration error: ${e.code}");
      switch (e.code) {
        case 'email-already-in-use':
          emit(AuthEmailAlreadyInUse());
          break;
        case 'invalid-email':
          emit(AuthInvalidEmail());
          break;
        case 'weak-password':
          emit(AuthWeakPassword());
          break;
        default:
          final errorHandler = FirebaseErrorHandler.handleError(e);
          emit(AuthError(errorHandler.errorMessage));
      }
      emit(UnAuthenticated());
    } catch (e) {
      LogsManager.error("Unexpected registration error: $e");
      emit(AuthError("auth.unexpectedError".tr()));
      emit(UnAuthenticated());
    }
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await authRepo.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      LogsManager.error("Get current user failed: $e");
      emit(AuthError("auth.checkUserFailed".tr()));
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
