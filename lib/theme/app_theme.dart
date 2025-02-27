import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF00FF00);
  static const backgroundColor = Color(0xFF1A1A1A);
  static const cardColor = Color(0xFF2A2A2A);

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.transparent,
    primaryColor: primaryColor,
    cardColor: cardColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: primaryColor,
      background: backgroundColor,
      surface: cardColor,
    ),
  );
}