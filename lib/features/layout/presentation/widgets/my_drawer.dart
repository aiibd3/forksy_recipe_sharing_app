import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/extensions/context_extension.dart';
import 'package:forksy/features/layout/presentation/widgets/my_drawer_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../search/presentation/pages/search_page.dart';
import 'language_toggle.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.whiteColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Icon(
                  Icons.person,
                  size: 50.sp,
                  color: Colors.black,
                ),
              ),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              MyDrawerTile(
                title: 'drawer.home'.tr(),
                icon: Icons.home_outlined,
                onTap: context.goBack,
              ),
              MyDrawerTile(
                title: 'drawer.profile'.tr(),
                icon: Icons.person,
                onTap: () {
                  context.goBack();
                  final user = context.read<AuthCubit>().currentUser;
                  String? uid = user!.uid;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        uid: uid,
                      ),
                    ),
                  );
                },
              ),
              MyDrawerTile(
                title: 'drawer.search'.tr(),
                icon: Icons.search,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                  ),
                ),
              ),
              SizedBox(
                height: 6.h,
              ),
              const LanguageToggle(),
              const Spacer(),
              MyDrawerTile(
                title: 'drawer.logout'.tr(),
                icon: Icons.logout,
                onTap: () async {
                  await context.read<AuthCubit>().logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
