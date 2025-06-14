import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'dart:developer';

import '../../../../core/routing/routes_name.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_font_styles.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../profile/data/repos/profile_repo.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../storage/data/repos/firebase_storage_repo.dart';
import '../cubit/layout_cubit.dart';
import '../widgets/profile/profile_card.dart';
import '../widgets/profile/settings_section.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  List<int> favoriteIndices = [];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileCubit(
            profileRepo: FirebaseProfileRepo(),
            storageRepo: FirebaseStorageRepo(),
          ),
        ),
        BlocProvider(
          create: (context) => LayoutCubit(),
        ),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          log('ProfileTab AuthCubit state: $state');
          if (state is UnAuthenticated) {
            log('ProfileTab navigating to ${RoutesName.auth}');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.go(RoutesName.auth);
              } else {
                log('ProfileTab context not mounted, navigation skipped');
              }
            });
          } else if (state is AuthError) {
            log('ProfileTab auth error: ${state.error}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            log('ProfileTab building with AuthCubit state: $authState');
            if (authState is UnAuthenticated || context.read<AuthCubit>().currentUser?.uid == null) {
              return const Center(
                child: Text(
                  'No user logged in.',
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else if (authState is Authenticated) {
              context.read<ProfileCubit>().fetchProfileUser(authState.user.uid);
              return BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, profileState) {
                  log('ProfileTab ProfileCubit state: $profileState');
                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPinnedHeader(
                        child: Container(
                          color: AppColors.whiteColor,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2.h),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Account',
                              style: AppFontStyles.poppins600_20,
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 2.h)),
                      SliverToBoxAdapter(
                        child: Builder(
                          builder: (context) {
                            if (profileState is ProfileLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              );
                            } else if (profileState is ProfileLoaded) {
                              final profileUser = profileState.user;
                              return ProfileCard(
                                name: profileUser.name,
                                role: profileUser.bio ?? 'No bio available',
                                imageUrl: profileUser.profileImage ?? 'assets/images/user2.png',
                                onTap: () {
                                  log('Navigating to ${RoutesName.profileFullPath}');
                                  context.goToNamed(RoutesName.profileFullPath);
                                },
                              );
                            } else if (profileState is ProfileFailure) {
                              return Center(
                                child: Text(
                                  'Failed to load profile: ${profileState.error}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            }
                            return const Center(
                              child: Text('No profile data available.'),
                            );
                          },
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: 2.h)),
                      const SliverToBoxAdapter(child: SettingsSection()),
                    ],
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}