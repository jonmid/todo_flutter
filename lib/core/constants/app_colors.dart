import 'package:flutter/material.dart';

class AppColors {
  // Primary purple colors from the design
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color lightPurple = Color(0xFFE0E7FF);
  static const Color darkPurple = Color(0xFF7C3AED);
  
  // Background colors
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color cardBackground = Colors.white;
  
  // Text colors
  static const Color primaryText = Color(0xFF1F2937);
  static const Color secondaryText = Color(0xFF6B7280);
  static const Color whiteText = Colors.white;
  
  // Task status colors
  static const Color completedTask = Color(0xFF10B981);
  static const Color pendingTask = Color(0xFFE5E7EB);
  
  // Accent colors
  static const Color accentColor = Color(0xFFEC4899);
  
  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
    ],
  );
}