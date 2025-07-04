import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/utils/logs_manager.dart';
import 'package:forksy/features/storage/domain/repos/storage_repo.dart';

import '../../../../core/errors/firebase_error_handler.dart';
import '../../domain/entities/profile_user.dart';
import '../../domain/repos/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({
    required this.storageRepo,
    required this.profileRepo,
  }) : super(ProfileInitial());

  Future<void> fetchProfileUser(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchProfileUser(uid);

      if (user != null) {
        emit(ProfileLoaded(user: user));
      } else {
        emit(ProfileFailure('User not found'));
      }
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
      emit(ProfileFailure(errorHandler.errorMessage));
    }
  }

  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchProfileUser(uid);
    return user;
  }

  Future<void> updateProfileUser({
    required String uid,
    String? newBio,
    String? imageProfilePath,
  }) async {
    try {
      emit(ProfileLoading());

      final currentUser = await profileRepo.fetchProfileUser(uid);
      if (currentUser == null) {
        emit(ProfileFailure('Failed to update user'));
        return;
      }

      String? imageDownloadUrl;

      if (imageProfilePath != null && imageProfilePath.isNotEmpty) {
        imageDownloadUrl =
            await storageRepo.uploadProfileImage(imageProfilePath, uid);
      }

      final updatedProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageURL: imageDownloadUrl ?? currentUser.profileImage,
      );

      await profileRepo.updateProfileUser(updatedProfile);

      await fetchProfileUser(uid);

      emit(ProfileLoaded(user: updatedProfile));
    } on FirebaseException catch (e) {
      final errorHandler = FirebaseErrorHandler.handleError(e);
      LogsManager.error(errorHandler.errorMessage);
      emit(
        ProfileFailure(errorHandler.errorMessage),
      );
    }
  }

  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      // emit(ProfileLoading());
      await profileRepo.toggleFollow(currentUid, targetUid);
    } catch (e) {
      LogsManager.error(e.toString());
      emit(ProfileFailure(e.toString()));
    }
  }
}
