import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppFontStyles {
  AppFontStyles._();

  static const Color defaultColor = AppColors.grayColor;

  static TextStyle _poppinsBaseStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }) {


    // return AppFonts.rubik(
    //   fontSize: fontSize,
    //   fontWeight: fontWeight,
    //   color: color,
    // );


    // ?
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Sofia Sans Styles
  static TextStyle poppins400_12 = _poppinsBaseStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: defaultColor,
  );

  static TextStyle poppins400_14 = _poppinsBaseStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: defaultColor,
  );
  static TextStyle poppins500_14 = _poppinsBaseStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: defaultColor,
  );

  static TextStyle poppins400_16 = _poppinsBaseStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: defaultColor,
  );
  static TextStyle poppins500_16 = _poppinsBaseStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: defaultColor,
  );
  static TextStyle poppins600_16 = _poppinsBaseStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: defaultColor,
  );
  static TextStyle poppins700_16 = _poppinsBaseStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: defaultColor,
  );
  static TextStyle poppins800_16 = _poppinsBaseStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: defaultColor,
  );

  static TextStyle poppins400_18 = _poppinsBaseStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: defaultColor,
  );
  static TextStyle poppins500_18 = _poppinsBaseStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: defaultColor,
  );
  static TextStyle poppins600_18 = _poppinsBaseStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: defaultColor,
  );
  static TextStyle poppins700_18 = _poppinsBaseStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: defaultColor,
  );
  static TextStyle poppinsBold_18 = _poppinsBaseStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: defaultColor,
  );
  static TextStyle poppins400_20 = _poppinsBaseStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: defaultColor,
  );

  static TextStyle poppins500_20 = _poppinsBaseStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: defaultColor,
  );

  static TextStyle poppins600_20 = _poppinsBaseStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: defaultColor,
  );

  static TextStyle poppins700_20 = _poppinsBaseStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: defaultColor,
  );

  static TextStyle poppinsBold_20 = _poppinsBaseStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: defaultColor,
  );

  static TextStyle poppins400_22 = _poppinsBaseStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: defaultColor,
  );

  static TextStyle poppins500_22 = _poppinsBaseStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: defaultColor,
  );

  static TextStyle poppins600_22 = _poppinsBaseStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: defaultColor,
  );

  static TextStyle poppins700_22 = _poppinsBaseStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: defaultColor,
  );

  static TextStyle poppinsBold_22 = _poppinsBaseStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: defaultColor,
  );

  static TextStyle poppins400_24 = _poppinsBaseStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: defaultColor,
  );
  static TextStyle poppins500_24 = _poppinsBaseStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: defaultColor,
  );
  static TextStyle poppins600_24 = _poppinsBaseStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: defaultColor,
  );
  static TextStyle poppins700_24 = _poppinsBaseStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: defaultColor,
  );
  static TextStyle poppinsBold_24 = _poppinsBaseStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: defaultColor,
  );
}
