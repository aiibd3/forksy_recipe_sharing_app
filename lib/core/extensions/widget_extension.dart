import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Widget setPageHorizontalPadding({double padding = 16}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: this,
    );
  }
}
