import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultHeader extends StatelessWidget {
  final String title;

  const DefaultHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
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
