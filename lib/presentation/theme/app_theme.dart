import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: UlimaColors.orange,
    colorScheme: ColorScheme.light(
      primary: UlimaColors.orange,
      onPrimary: UlimaColors.orangeDark,
      secondary: UlimaColors.grayMid,
      onSecondary: UlimaColors.grayDark,
      background: UlimaColors.white,
    ),
    scaffoldBackgroundColor: UlimaColors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: UlimaColors.orange,
      foregroundColor: UlimaColors.white,
    ),
    textTheme: TextTheme(
      headlineLarge:
          AppTextStyles.headline1.copyWith(color: UlimaColors.grayDark),
      headlineMedium:
          AppTextStyles.headline2.copyWith(color: UlimaColors.grayDark),
      bodyLarge: AppTextStyles.body1.copyWith(color: UlimaColors.grayDark),
      bodyMedium: AppTextStyles.body2.copyWith(color: UlimaColors.grayDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: UlimaColors.orange,
        foregroundColor: UlimaColors.white,
        textStyle: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: UlimaColors.orange,
      unselectedItemColor: UlimaColors.grayMid,
      backgroundColor: UlimaColors.grayDark,
      type: BottomNavigationBarType.fixed,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: UlimaColors.orange,
    colorScheme: ColorScheme.dark(
      primary: UlimaColors.orange, // color principal
      secondary: UlimaColors.grayMid, // color secundario
      background: UlimaColors.grayDark, // fondo del scaffold
      surface: UlimaColors.grayDark, // fondo de tarjetas, etc.
    ),
    scaffoldBackgroundColor: UlimaColors.grayDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: UlimaColors.orange,
      foregroundColor: UlimaColors.white,
    ),
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.headline1.copyWith(color: UlimaColors.white),
      headlineMedium:
          AppTextStyles.headline2.copyWith(color: UlimaColors.white),
      bodyLarge: AppTextStyles.body1.copyWith(color: UlimaColors.white),
      bodyMedium: AppTextStyles.body2.copyWith(color: UlimaColors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: UlimaColors.orange,
      unselectedItemColor: UlimaColors.grayMid,
      backgroundColor: UlimaColors.grayDark,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
