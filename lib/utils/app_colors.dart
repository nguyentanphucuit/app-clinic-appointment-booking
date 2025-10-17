import 'package:flutter/cupertino.dart';

class AppColors {
  // Primary Colors - Medical Blue/Teal Theme
  static const Color primary = Color(0xFF0EA5E9); // Sky Blue
  static const Color primaryDark = Color(0xFF0284C7);
  static const Color primaryLight = Color(0xFF7DD3FC);

  // Secondary Colors
  static const Color secondary = Color(0xFF10B981); // Emerald
  static const Color secondaryDark = Color(0xFF059669);
  static const Color secondaryLight = Color(0xFF6EE7B7);

  // Accent Colors
  static const Color accent = Color(0xFF8B5CF6); // Purple
  static const Color accentLight = Color(0xFFA78BFA);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Appointment Status Colors
  static const Color upcoming = Color(0xFF0EA5E9);
  static const Color completed = Color(0xFF10B981);
  static const Color cancelled = Color(0xFFEF4444);

  // Specialty Colors
  static const Color cardiology = Color(0xFFEF4444);
  static const Color dermatology = Color(0xFFF59E0B);
  static const Color neurology = Color(0xFF8B5CF6);
  static const Color pediatrics = Color(0xFF10B981);
  static const Color orthopedics = Color(0xFF3B82F6);
  static const Color psychiatry = Color(0xFFEC4899);
  static const Color general = Color(0xFF06B6D4);
  static const Color dentistry = Color(0xFF14B8A6);

  // Neutral Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border & Divider
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Shadow
  static const Color shadow = Color(0x1A000000);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF0EA5E9),
    Color(0xFF06B6D4),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF10B981),
    Color(0xFF059669),
  ];

  static const List<Color> purpleGradient = [
    Color(0xFF8B5CF6),
    Color(0xFFA78BFA),
  ];

  static const List<Color> cardGradient = [
    Color(0xFFFFFFFF),
    Color(0xFFF8FAFC),
  ];
}
