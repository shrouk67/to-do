import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyle {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.lightPrimaryColor,
      toolbarHeight: 157,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightPrimaryColor,
      shape: StadiumBorder(
        side: BorderSide(
          color: Colors.white,
          width: 4,
        ),
      ),
    ),
    textTheme: const TextTheme(
      labelSmall: TextStyle(
        fontSize: 14,
        color: AppColors.labelColor,
      ),
      titleSmall: TextStyle(
        fontSize: 18,
        color: Colors.black,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.lightPrimaryColor,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.green,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.lightPrimaryColor,
    ),
    useMaterial3: false,
  );
}
