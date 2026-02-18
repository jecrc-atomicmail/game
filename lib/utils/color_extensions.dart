import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  /// A light wrapper for `withAlpha` that avoids calling `const`-error-prone APIs.
  Color withOpacityValue(double opacity) {
    final clamped = opacity.clamp(0, 1);
    return withAlpha((clamped * 0xFF).round());
  }
}
