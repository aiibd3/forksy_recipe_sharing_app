import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/utils/logs_manager.dart';
import '../../../../posts/presentation/cubit/post_cubit.dart';
import '../../cubit/layout_cubit.dart';
import '../../../domain/entities/category_entities.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'category_item.dart';

class CategoryPage extends StatelessWidget {
  final VoidCallback? onShowAll;

  const CategoryPage({super.key, this.onShowAll});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryCubit()..fetchCategories(),
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return SizedBox(
              height: 15.h,
              child: Center(
                child: AnimatedRotation(
                  turns: 0.5,
                  duration: const Duration(seconds: 1),
                  child: CircularProgressIndicator(
                      color: AppColors.primaryColor, strokeWidth: 2.sp),
                ),
              ),
            );
          } else if (state is CategoryLoaded) {
            final allCategories = [
              CategoryEntity(
                  id: 'all', title: 'all', imageUrl: 'assets/images/all.png'),
              ...state.categories,
            ];
            return Container(
              height: 15.h,
              color: Colors.white,
              child: ListView.separated(
                separatorBuilder: (context, index) => Gap(2.w),
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                itemCount: allCategories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.read<CategoryCubit>().setActiveCategory(index);
                      LogsManager.info(
                          "Selected category: ${allCategories[index].id}");
                      if (index == 0) {
                        onShowAll?.call();
                      } else {
                        context
                            .read<PostCubit>()
                            .fetchPostsByCategory(allCategories[index].id);
                      }
                    },
                    child: CategoryItem(
                      category: allCategories[index],
                      isActive: index == state.activeIndex,
                    ),
                  );
                },
              ),
            );
          } else if (state is CategoryError) {
            return SizedBox(
              height: 15.h,
              child: Center(
                  child: Text(
                      "${"posts.unexpectedError".tr()}: ${state.message}",
                      style: TextStyle(fontSize: 16.sp))),
            );
          }
          return SizedBox(height: 15.h, child: Container());
        },
      ),
    );
  }
}
