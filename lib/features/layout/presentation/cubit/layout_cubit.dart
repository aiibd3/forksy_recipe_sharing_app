import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/utils/logs_manager.dart';
import '../../../bot/presentation/pages/bot_page.dart';
import '../../data/repos/category_repository_impl.dart';
import '../../domain/entities/category_entities.dart';
import '../../domain/repos/category_repository.dart';
import '../pages/home_tab.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutInitial());

  static LayoutCubit get(BuildContext context) =>
      BlocProvider.of<LayoutCubit>(context);

  int activeTabIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  List<Widget> pages = [
    const HomeTab(),
    const BotPage(),
  ];

  void changeTab(int index) {
    activeTabIndex = index;
    pageController.animateToPage(
      activeTabIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    emit(ChangeTabState());
  }
}

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepo categoryRepo;

  CategoryCubit()
      : categoryRepo = FirebaseCategoryRepo(),
        super(CategoryInitial());

  Future<void> fetchCategories() async {
    try {
      emit(CategoryLoading());
      final categories = await categoryRepo.fetchCategories();
      LogsManager.info("Fetched ${categories.length} categories");
      emit(CategoryLoaded(categories));
    } catch (e) {
      LogsManager.error("Error fetching categories: $e");
      emit(CategoryError("posts.unexpectedError".tr()));
    }
  }

  void setActiveCategory(int index) {
    if (state is CategoryLoaded) {
      final currentState = state as CategoryLoaded;
      LogsManager.info("Setting active category index: $index");
      emit(CategoryLoaded(currentState.categories, activeIndex: index));
    }
  }
}