// lib/core/theme/app_theme.dart

import 'package:eat_easy_assignment/core/utils/imports.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1C1C1E),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: const Color(0xFF1C1C1E),
      titleTextStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: 'Radley',
      ),
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF2C2C2E),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Radley',
      ),
      titleMedium: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Radley',
      ),
      titleSmall: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12.sp,
        fontFamily: 'Radley',
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontFamily: 'Radley',
      ),
      bodyMedium: TextStyle(
        color: Colors.white.withOpacity(0.87),
        fontSize: 12.sp,
        fontFamily: 'Radley',
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF3C3C3E),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: const Color(0xFF2C2C2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
