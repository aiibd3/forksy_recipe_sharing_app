import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/errors/firebase_error_handler.dart';
import 'package:forksy/core/services/hive_storage.dart';
import 'package:forksy/core/utils/logs_manager.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repos/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AppUser? _currentUser;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static AuthCubit get(BuildContext context) =>
      BlocProvider.of<AuthCubit>(context);

  AuthCubit({required this.authRepo}) : super(AuthInitial()) {
    listenToAuthState();
  }

  void listenToAuthState() {
    LogsManager.info('Starting auth state listener');
    _firebaseAuth.authStateChanges().listen((user) async {
      try {
        if (user == null) {
          LogsManager.info('Auth state: User signed out');
          _currentUser = null;
          await HiveStorage.clearUserData();
          emit(UnAuthenticated());
        } else {
          LogsManager.info('Auth state: User signed in, UID: ${user.uid}');
          final appUser = await authRepo.getCurrentUser();
          if (appUser != null) {
            _currentUser = appUser;
            emit(Authenticated(appUser));
          } else {
            LogsManager.warning('No AppUser found for UID: ${user.uid}');
            emit(UnAuthenticated());
          }
        }
      } catch (e, stackTrace) {
        LogsManager.error('Error in authStateChanges: $e\n$stackTrace');
        emit(UnAuthenticated());
      }
    }, onError: (error, stackTrace) {
      LogsManager.error('authStateChanges error: $error\n$stackTrace');
      emit(UnAuthenticated());
    });
  }

  Future<void> checkUserIsLogged() async {
    emit(AuthLoading());
    try {
      final user = await authRepo.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        LogsManager.info('User logged in: ${user.uid}');
        emit(Authenticated(user));
      } else {
        _currentUser = null;
        LogsManager.info('No user logged in');
        emit(UnAuthenticated());
      }
    } catch (e, stackTrace) {
      LogsManager.error('Error checking user login: $e\n$stackTrace');
      emit(UnAuthenticated());
    }
  }

  AppUser? get currentUser => _currentUser;

  Future<void> login(String email, String password) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailPassword(email, password);
      if (user != null) {
        _currentUser = user;
        LogsManager.info('Login successful: ${user.uid}');
        emit(Authenticated(user));
      } else {
        LogsManager.warning('Login failed: No user returned');
        emit(UnAuthenticated());
      }
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error('Login error: ${errorHandler.errorMessage}');
      emit(AuthError(errorHandler.errorMessage));
      emit(UnAuthenticated());
    } catch (e, stackTrace) {
      LogsManager.error('Unexpected login error: $e\n$stackTrace');
      emit(AuthError('Unexpected error: $e'));
      emit(UnAuthenticated());
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.registerWithEmailPassword(name, email, password);
      if (user != null) {
        _currentUser = user;
        LogsManager.info('Registration successful: ${user.uid}');
        emit(Authenticated(user));
      } else {
        LogsManager.warning('Registration failed: No user returned');
        emit(UnAuthenticated());
      }
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error('Registration error: ${errorHandler.errorMessage}');
      emit(AuthError(errorHandler.errorMessage));
      emit(UnAuthenticated());
    } catch (e, stackTrace) {
      LogsManager.error('Unexpected registration error: $e\n$stackTrace');
      emit(AuthError('Unexpected error: $e'));
      emit(UnAuthenticated());
    }
  }

  Future<void> logout() async {
    try {
      emit(AuthLoading());
      LogsManager.info('Initiating logout');
      await authRepo.logout();
      await HiveStorage.clearUserData();
      _currentUser = null;
      LogsManager.info('Logout successful');
      emit(UnAuthenticated());
    } catch (e, stackTrace) {
      LogsManager.error('Logout error: $e\n$stackTrace');
      emit(AuthError('Logout failed: $e'));
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