import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bot/presentation/pages/bot_page.dart';
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
