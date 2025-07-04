import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class MyScaffold extends StatelessWidget {
  final Widget child;
  const MyScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
      color: AppColors.whiteColor,

      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: child,
      ),
    );
  }
}
