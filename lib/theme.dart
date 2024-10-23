import 'package:flutter/material.dart';

class AppTheme {
  static const Color accentColor = Color(0xFF5E9EFF);
  static const Color secondaryColor = Color(0xFF46A0AE);
  static const Color shadow = Color(0xFF4A5367);
  static const Color shadowDark = Color(0xFF000000);
  static const Color background = Color(0xFFF2F6FF);
  static const Color light_bg = Color(0xfff4f3fa);
  static const Color backgroundDark = Color(0xFF25254B);
  static const Color background2 = Color(0xFF17203A);
  static const Color white = Color(0xFFffffff);
  static const Color danger = Color(0xffff6969);
  static const Color green = Color(0xFF00C74D);
  static const Color splash_screen_color = Color(0xffffffff);
  static const Color transparent = Colors.transparent;
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const secondaryGradient = LinearGradient(
    colors: [AppTheme.accentColor, AppTheme.secondaryColor],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const double defaultPadding = 20.0;
}