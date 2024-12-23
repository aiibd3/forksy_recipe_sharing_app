import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/extensions/widget_extension.dart';
import 'package:forksy/features/layout/presentation/widgets/profile/setting_list_item.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../cubit/layout_cubit.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit(),
      child: BlocBuilder<LayoutCubit, LayoutState>(
        builder: (context, state) {
          return Container(
            constraints: BoxConstraints(maxHeight: 80.h), // Constrain height
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 2.h),
                  SettingsListItem(
                    onTap: () {
                      // context.goToNamed(RoutesName.myAddressFullPath);
                    },
                    title: "Addresses",
                    icon: EneftyIcons.location_add_bold,
                  ),
                  SizedBox(height: 2.h),
                  const Divider(
                    height: 1,
                    thickness: 0.5,
                    color: AppColors.secondaryColor,
                  ),
                  SizedBox(height: 2.h),
                  SettingsListItem(
                    onTap: () {
                      // Handle language change
                    },
                    title: "Language",
                    icon: EneftyIcons.language_circle_bold,
                  ),
                  SizedBox(height: 2.h),
                  const Divider(
                    height: 1,
                    thickness: 0.5,
                    color: AppColors.secondaryColor,
                  ),
                  SizedBox(height: 2.h),
                  SettingsListItem(
                    onTap: () {},
                    title: "Privacy",
                    icon: EneftyIcons.text_block_bold,
                  ),
                  SizedBox(height: 2.h),
                  const Divider(
                    height: 1,
                    thickness: 0.5,
                    color: AppColors.secondaryColor,
                  ),
                  SizedBox(height: 2.h),
                  SettingsListItem(
                    onTap: () {},
                    title: "Saves",
                    icon: EneftyIcons.text_block_bold,
                  ),
                  SizedBox(height: 2.h),
                  const Divider(
                    height: 1,
                    thickness: 0.5,
                    color: AppColors.secondaryColor,
                  ),
                  SizedBox(height: 2.h),
                  SettingsListItem(
                    onTap: () {},
                    title: "Likes",
                    icon: EneftyIcons.text_block_bold,
                  ),
                ],
              ).setPageHorizontalPadding(),
            ),
          );
        },
      ),
    );
  }
}
