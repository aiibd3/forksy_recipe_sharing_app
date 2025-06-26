import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forksy/core/extensions/context_extension.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/theme/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/widgets/custom_button.dart';
import '../cubit/onboarding_cubit.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  List<String> titles = [];
  List<String> descriptions = [];
  int _curPage = 0;
  final _animationDuration = const Duration(milliseconds: 500);

  late AssetImage image1;
  late AssetImage image2;
  late AssetImage image3;

  @override
  void initState() {
    super.initState();
    image1 = const AssetImage(AppAssets.onBoarding1);
    image2 = const AssetImage(AppAssets.onBoarding2);
    image3 = const AssetImage(AppAssets.onBoarding3);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    titles = [
      "Discover Recipes You’ll Love",
      "Cook with Confidence",
      "Share Your Creations",
    ];

    descriptions = [
      "Browse a vast collection of delicious recipes shared by food enthusiasts worldwide. Find the perfect meal for every occasion.",
      "Follow step-by-step instructions and tips to create mouthwatering dishes. Cooking has never been this easy and fun!",
      "Show off your culinary skills by sharing your favorite recipes with the community. Inspire others with your unique ideas.",
    ];

    precacheImage(image1, context);
    precacheImage(image2, context);
    precacheImage(image3, context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is GoToRouteState) {
          context.goToReplace(state.route);
        } else if (state is OnboardingLoadedFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: 75.h,
              child: PageView(
                onPageChanged: (value) {
                  _changePageView(value);
                },
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                children: [
                  Image(image: image1, fit: BoxFit.cover),
                  Image(image: image2, fit: BoxFit.cover),
                  Image(image: image3, fit: BoxFit.cover),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: SwapEffect(
                    activeDotColor: AppColors.primaryColor,
                    dotColor: Colors.white.withOpacity(0.7),
                    dotHeight: 12.0,
                    dotWidth: 12.0,
                    spacing: 8.0,
                  ),
                  onDotClicked: null,
                ),
                const SizedBox(height: 20),
                Container(
                  height: 35.h,
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Spacer(),
                      FadeInRight(
                        key: UniqueKey(),
                        child: Text(
                          titles[_curPage],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 21.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.rubik,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      FadeInLeft(
                        key: UniqueKey(),
                        child: Text(
                          descriptions[_curPage],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0.sp,
                            fontFamily: AppFonts.rubik,
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 50.w,
                        child: CustomButton(
                          onPressed: () {
                            _clickOnNext();
                          },
                          label: _curPage != 2 ? "Next" : "Get Started",
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _clickOnNext() {
    if (_curPage == 2) {
      context.read<OnboardingCubit>().completeOnboarding();
      return;
    }
    _pageController.nextPage(
      duration: _animationDuration,
      curve: Curves.linearToEaseOut,
    );
    _curPage++;
  }

  void _changePageView(int nextPage) {
    _pageController.animateToPage(
      nextPage,
      duration: _animationDuration,
      curve: Curves.linearToEaseOut,
    );
    _curPage = nextPage;
    setState(() {});
  }
}