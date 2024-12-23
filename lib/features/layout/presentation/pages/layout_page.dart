import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/layout_cubit.dart';

class LayoutPage extends StatelessWidget {
  const LayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit(),
      child: BlocBuilder<LayoutCubit, LayoutState>(
        builder: (context, state) {
          return _LayoutPageBody();
        },
      ),
    );
  }
}

class _LayoutPageBody extends StatelessWidget {
  _LayoutPageBody();

  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit, LayoutState>(
      builder: (context, state) {
        var cubit = LayoutCubit.get(context);

        return Scaffold(
          backgroundColor: AppColors.whiteColor,
          extendBody: true,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            backgroundColor: AppColors.secondaryColor,
            shape: const CircleBorder(),
            onPressed: () {
              // context.goToNamed(RoutesName.cartFullPath);
            },
            child: Icon(
              EneftyIcons.add_outline,
              color: AppColors.whiteColor,
              size: 25.sp,
            ),
          ),
          bottomNavigationBar: AnimatedBottomNavigationBar(
            elevation: 0.0,
            activeIndex: cubit.activeTabIndex,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.verySmoothEdge,
            backgroundColor: AppColors.whiteColor,
            activeColor: AppColors.primaryColor,
            inactiveColor: AppColors.grayColor,
            splashColor: AppColors.primaryColor,
            notchMargin: 12.sp,
            borderColor: Colors.black.withOpacity(0.01),
            onTap: (index) {
              cubit.changeTab(index);
            },
            icons: const [
              EneftyIcons.home_outline,
              EneftyIcons.user_outline,
            ],
          ),
          body: Center(
            child: SafeArea(
              bottom: false,
              child: PageView(
                controller: cubit.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: cubit.pages,
              ),
            ),
          ),
        );
      },
    );
  }
}
