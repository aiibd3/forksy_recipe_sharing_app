import 'package:flutter/material.dart';
import 'package:forksy/core/extensions/context_extension.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../../core/routing/routes_name.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_font_styles.dart';
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
          child: ProfileCard(
            name: 'AbdulRahman Hamoud',
            role: 'Flutter Developer',
            imageUrl: 'assets/images/hamoud.jpg',
            onTap: () {
              context.goToNamed(RoutesName.profileFullPath);
            },
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
