import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/firebase_error_handler.dart';
import '../../../../core/utils/logs_manager.dart';
import '../../../auth/domain/repos/auth_repo.dart';
import '../../domain/entities/profile_user.dart';
import '../../domain/repos/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final AuthRepo authRepo;

  ProfileCubit({required this.authRepo, required this.profileRepo})
      : super(ProfileInitial());




  // Fetch user profile by UID
  Future<void> fetchProfileUser(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchProfileUser(uid);
      if (user != null) {
        emit(ProfileLoadedSuccess(user: user));
      } else {
        emit(ProfileLoadedFailure('User not found'));
      }
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
      emit(ProfileLoadedFailure(errorHandler.errorMessage));
    }
  }

  // Update user profile
  Future<void> updateProfileUser(String uid, ProfileUser updatedUser) async {
    try {
      emit(ProfileLoading());

      final currentUser = await profileRepo.fetchProfileUser(uid);
      if (currentUser == null) {
        emit(ProfileLoadedFailure('User not found'));
        return;
      }

      // Update user in the repository
      await profileRepo.updateProfileUser(updatedUser);

      // Emit success with the updated user
      emit(ProfileLoadedSuccess(user: updatedUser));
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
      emit(ProfileLoadedFailure(errorHandler.errorMessage));
    }
  }
}
