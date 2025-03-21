import 'package:flutter/material.dart';
import 'package:task_manager_app/core/constants/app_colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.lightBackground,
  cardColor: AppColors.lightCard,
  primaryColor: AppColors.lightPrimary,
  iconTheme: IconThemeData(color: AppColors.lightPrimary),
  textTheme: TextTheme(bodyLarge: TextStyle(color: AppColors.lightText)),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.darkBackground,
  cardColor: AppColors.darkCard,
  primaryColor: AppColors.darkPrimary,
  iconTheme: IconThemeData(color: AppColors.darkPrimary),
  textTheme: TextTheme(bodyLarge: TextStyle(color: AppColors.darkText)),
);
