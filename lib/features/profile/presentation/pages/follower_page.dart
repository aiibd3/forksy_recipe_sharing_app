import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/user_tile.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;

  const FollowerPage({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          title: Text(
            "profile.followers".tr(),
          ),
          bottom: TabBar(
            dividerColor: AppColors.secondaryColor,
            labelColor: AppColors.secondaryColor,
            unselectedLabelColor: AppColors.grayColor,
            indicatorColor: AppColors.secondaryColor,
            tabs: [
              Tab(text: "profile.followers".tr()),
              Tab(text: "profile.following".tr()),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildStatColumn(followers, "profile.noFollowers".tr(), context),
            _buildStatColumn(following, "profile.noFollowing".tr(), context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(
      List<String> uids, String emptyMessage, BuildContext context) {
    return uids.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/emtpy.json',
                  height: 20.h,
                ),
                Text(
                  emptyMessage.tr(),
                  style: TextStyle(fontSize: 16.sp),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: uids.length,
            itemBuilder: (context, index) {
              final uid = uids[index];
              return FutureBuilder(
                future: context.read<ProfileCubit>().getUserProfile(uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final user = snapshot.data;
                    return UserTile(user: user!);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                      leading: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  } else {
                    return ListTile(
                      title: Text("profile.error".tr(),
                          style: TextStyle(fontSize: 16.sp)),
                      trailing: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () =>
                            context.read<ProfileCubit>().getUserProfile(uid),
                      ),
                    );
                  }
                },
              );
            },
          );
  }
}
