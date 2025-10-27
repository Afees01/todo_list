import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF9C27B0);
  static const Color primaryDark = Color(0xFF673AB7);
  static const Color primaryLight = Color(0xFFE1BEE7);

  // Project Colors
  static const Color projectPink = Color(0xFFFF6B9D);
  static const Color projectPurple = Color(0xFF9C27B0);
  static const Color projectOrange = Color(0xFFFF9800);
  static const Color projectGreen = Color(0xFF4CAF50);
  static const Color projectBlue = Color(0xFF2196F3);

  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  static const Color textDisabled = Color(0xFFCCCCCC);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Shadow Colors
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowMedium = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xFFE8F4FD),
      Color(0xFFFFF3E0),
      Color(0xFFFFE0E6),
      Color(0xFFE8F5E8),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class ProjectColorUtils {
  static const Map<String, Color> projectColors = {
    '#FF6B9D': AppColors.projectPink,
    '#9C27B0': AppColors.projectPurple,
    '#FF9800': AppColors.projectOrange,
    '#4CAF50': AppColors.projectGreen,
    '#2196F3': AppColors.projectBlue,
  };

  static const Map<String, IconData> projectIcons = {
    '#FF6B9D': Icons.business_outlined,
    '#9C27B0': Icons.person_outline,
    '#FF9800': Icons.book_outlined,
    '#4CAF50': Icons.home_outlined,
    '#2196F3': Icons.fitness_center_outlined,
  };

  static Color getProjectColor(String colorHex) {
    return projectColors[colorHex] ?? AppColors.projectPurple;
  }

  static IconData getProjectIcon(String colorHex) {
    return projectIcons[colorHex] ?? Icons.work_outline;
  }

  static List<Map<String, dynamic>> getColorOptions() {
    return [
      {'color': '#FF6B9D', 'name': 'Pink', 'icon': Icons.business_outlined},
      {'color': '#9C27B0', 'name': 'Purple', 'icon': Icons.person_outline},
      {'color': '#FF9800', 'name': 'Orange', 'icon': Icons.book_outlined},
      {'color': '#4CAF50', 'name': 'Green', 'icon': Icons.home_outlined},
      {
        'color': '#2196F3',
        'name': 'Blue',
        'icon': Icons.fitness_center_outlined
      },
    ];
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 2,
        shadowColor: AppColors.shadowLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: AppColors.shadowMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
