import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;

import '../../../../core/theme/app_colors.dart';

class MyDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;

  const MyDrawerTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      onTap: onTap,
      trailing: Directionality(
        textDirection: TextDirection.ltr,
        child: Icon(
          context.locale.languageCode == "en"
              ? Icons.arrow_forward_ios
              : Icons.arrow_back_ios,
          color: AppColors.secondaryColor,
          size: 20,
        ),
      ),
    );
  }
}
