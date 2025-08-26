import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import 'typography.dart';

class AppTheme {
  /// Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32.sp,
        fontFamily: Typo.playfairBold,
        color: AppColors.primary,
      ),
      bodyLarge: TextStyle(
        fontSize: 18.sp,
        fontFamily: Typo.medium,
        color: Colors.black87,
      ),
      labelLarge: TextStyle(
        fontSize: 16.sp,
        fontFamily: Typo.semiBold,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        textStyle: TextStyle(fontSize: 16.sp, fontFamily: Typo.semiBold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  /// Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32.sp,
        fontFamily: Typo.playfairBold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 18.sp,
        fontFamily: Typo.medium,
        color: Colors.white70,
      ),
      labelLarge: TextStyle(
        fontSize: 16.sp,
        fontFamily: Typo.semiBold,
        color: Colors.black,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontFamily: Typo.semiBold,
          color: Colors.black,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
