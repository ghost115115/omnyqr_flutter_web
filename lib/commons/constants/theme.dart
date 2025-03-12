import 'package:flutter/material.dart';

import 'omny_colors.dart';

final ThemeData appTheme = ThemeData(
  fontFamily: 'Inter',
  useMaterial3: false,
  scaffoldBackgroundColor: AppColors.scaffoldBackground,
  textSelectionTheme: const TextSelectionThemeData(
    selectionHandleColor: AppColors.formBorderColor,
  ),
);
