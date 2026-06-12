import 'package:flutter/material.dart';

/// The three behavioral indicator types in the Amomimus app.
///
/// - **cloudy** (grey)  — Neutral user (benevolent points 0–49)
/// - **ghost** (yellow)  — Amoral / nonchalant user (benevolent points 50–79)
/// - **noise** (purple)  — Immoral / toxic user (benevolent points 80–100)
enum UserIndicator { cloudy, ghost, noise }

/// UI and logic helpers for [UserIndicator].
class UserIndicatorHelper {
  UserIndicatorHelper._(); // prevent instantiation

  // ── Colors ──────────────────────────────────────────────
  static const Color cloudyColor = Color(0xFFBDBDBD); // grey
  static const Color ghostColor = Color(0xFFFFD54F);  // yellow
  static const Color noiseColor = Color(0xFFB388FF);  // purple

  /// Returns the theme [Color] for the given [indicator].
  static Color getColor(UserIndicator indicator) {
    switch (indicator) {
      case UserIndicator.cloudy:
        return cloudyColor;
      case UserIndicator.ghost:
        return ghostColor;
      case UserIndicator.noise:
        return noiseColor;
    }
  }

  /// Returns the display label for the given [indicator].
  static String getLabel(UserIndicator indicator) {
    switch (indicator) {
      case UserIndicator.cloudy:
        return 'CLOUDY';
      case UserIndicator.ghost:
        return 'GHOST';
      case UserIndicator.noise:
        return 'NOISE';
    }
  }

  /// Returns a short description of the indicator.
  static String getDescription(UserIndicator indicator) {
    switch (indicator) {
      case UserIndicator.cloudy:
        return 'Neutral user';
      case UserIndicator.ghost:
        return 'Amoral / nonchalant user';
      case UserIndicator.noise:
        return 'Flagged / Toxic user';
    }
  }

  /// Returns the [IconData] for the given [indicator].
  static IconData getIcon(UserIndicator indicator) {
    switch (indicator) {
      case UserIndicator.cloudy:
        return Icons.cloud_outlined;
      case UserIndicator.ghost:
        return Icons.visibility_off_outlined;
      case UserIndicator.noise:
        return Icons.warning_amber_rounded;
    }
  }

  // ── Serialization ──────────────────────────────────────

  /// Converts a [UserIndicator] to a storable string.
  static String toValue(UserIndicator indicator) {
    return indicator.name; // 'cloudy', 'ghost', 'noise'
  }

  /// Parses a stored string back into a [UserIndicator].
  /// Defaults to [UserIndicator.cloudy] for unknown values.
  static UserIndicator fromValue(String? value) {
    switch (value) {
      case 'ghost':
        return UserIndicator.ghost;
      case 'noise':
        return UserIndicator.noise;
      case 'cloudy':
      default:
        return UserIndicator.cloudy;
    }
  }

  // ── Calculation ────────────────────────────────────────

  /// Determines the indicator from benevolent points alone.
  ///
  /// - 0–49 → CLOUDY
  /// - 50–79 → GHOST
  /// - 80–100 → NOISE
  static UserIndicator fromBenevolentPoints(int points) {
    final clamped = points.clamp(0, 100);
    if (clamped >= 80) {
      return UserIndicator.noise;
    } else if (clamped >= 50) {
      return UserIndicator.ghost;
    }
    return UserIndicator.cloudy;
  }
}
