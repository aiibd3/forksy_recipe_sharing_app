import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/extensions/context_extension.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../../core/routing/routes_name.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_font_styles.dart';
import '../../../auth/data/repos/auth_repo.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../profile/data/repos/profile_repo.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../storage/data/repos/firebase_storage_repo.dart';
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
                "Account",
                style: AppFontStyles.poppins600_20,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
            child: SizedBox(
          height: 2.h,
        )),
        SliverToBoxAdapter(
          child: BlocProvider(
            create: (context) => ProfileCubit(
              profileRepo: FirebaseProfileRepo(),
              storageRepo: FirebaseStorageRepo(),
              authRepo: FirebaseAuthRepo(),
            )..fetchProfileUser(
                context.read<AuthCubit>().currentUser?.uid ?? ''),
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primaryColor),
                  );
                } else if (state is ProfileLoaded) {
                  final profileUser = state.user;

                  return ProfileCard(
                    name: profileUser.name,
                    role: profileUser.bio ?? 'No bio available',
                    imageUrl: profileUser.profileImage ??
                        'assets/images/default_avatar.png',
                    onTap: () {
                      context.goToNamed(RoutesName.profileFullPath);
                    },
                  );
                } else if (state is ProfileFailure) {
                  return Center(
                    child: Text(
                      'Failed to load profile: ${state.error}',
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
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 2.h,
          ),
        ),
        const SliverToBoxAdapter(
          child: SettingsSection(),
        ),
      ],
    );
  }
}
