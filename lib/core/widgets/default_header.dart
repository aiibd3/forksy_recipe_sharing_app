import 'package:flutter/material.dart';
import 'package:forksy/core/extensions/context_extension.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultHeader extends StatelessWidget {
  final String title;
  final bool hasBackButton;

  const DefaultHeader({
    super.key,
    required this.title,
    this.hasBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Visibility(
          visible: hasBackButton,
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                context.goBack();
              },
              icon: const Icon(Icons.arrow_back_ios_rounded),
            ),
          ),
        ),
        Text(
          title,
          style: GoogleFonts.readexPro().copyWith(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
