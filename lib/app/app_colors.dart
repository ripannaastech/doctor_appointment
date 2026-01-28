import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const Color themeColor = Color(0xFF266FEF);
  static const Color grey = Color(0xFFD0D5DD);

  /// Light → theme gradient (most common)
  static LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF5C8DFF), // lighter theme
      themeColor,
    ],
  );
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4F6EF7), // modern soft blue
      Color(0xFF3F5AE0), // refined deep blue
    ],
  );




  static const LinearGradient softCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEAF1FF),
      Color(0xFFDDE8FF),
    ],
  );
  /// Soft card gradient (very subtle)
  static LinearGradient softPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      themeColor.withOpacity(0.12),
      themeColor.withOpacity(0.22),
    ],
  );
}
