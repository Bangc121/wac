import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF004D40); // Dark Teal from Figma
  static const Color secondary = Color(
    0xFF10B981,
  ); // Emerald Green (Keep legacy if needed, or remove)

  // Social Colors
  static const Color kakao = Color(0xFFFEE500);
  static const Color naver = Color(0xFF03C75A);

  // Neutral Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF3F4F6); // Light Grey Surface
  static const Color textPrimary = Color(0xFF111111); // Near Black
  static const Color textSecondary = Color(0xFF6B7280); // Medium Gray
  static const Color border = Color(0xFFE5E7EB);

  // Error/Success
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  // Dark Mode Specific
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
}
