import 'package:flutter/material.dart';

import '../models/post_model.dart';

/// UI-concern helpers for resolving visual properties from gender/AccountType.
///
/// These helpers were previously embedded inside [FeedModel] and are now
/// extracted so the data model stays pure.
class GenderHelpers {
  GenderHelpers._(); // prevent instantiation

  /// Returns the theme [Color] for the given [AccountType].
  static Color getTypeColor(AccountType type) {
    switch (type) {
      case AccountType.amo:
        return const Color(0xFFB388FF);
      case AccountType.ami:
        return const Color(0xFF9E9E9E);
      case AccountType.amom:
        return const Color(0xFFFFD54F);
      case AccountType.user:
        return const Color(0xFF8C72C4);
    }
  }

  /// Returns the [IconData] for the given [AccountType].
  static IconData getTypeIcon(AccountType type) {
    switch (type) {
      case AccountType.amo:
        return Icons.diamond;
      case AccountType.ami:
        return Icons.water;
      case AccountType.amom:
        return Icons.android;
      case AccountType.user:
        return Icons.person;
    }
  }

  /// Returns the [TextStyle] for the ID label for the given [AccountType].
  static TextStyle getTypeIdTextStyle(AccountType type) {
    switch (type) {
      case AccountType.amo:
        return const TextStyle(
          letterSpacing: 1.5,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFFB388FF),
        );
      case AccountType.ami:
        return const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF9E9E9E),
        );
      case AccountType.amom:
        return const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFD54F),
        );
      case AccountType.user:
        return const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        );
    }
  }

  /// Returns the theme [Color] for a gender string ('Amo', 'Ami', 'Amom').
  static Color getGenderColor(String gender) {
    switch (gender) {
      case 'Ami':
        return const Color(0xFF9E9E9E);
      case 'Amom':
        return const Color(0xFFFFD54F);
      case 'Amo':
      default:
        return const Color(0xFFB388FF);
    }
  }

  /// Returns the [IconData] for a gender string.
  static IconData getGenderIcon(String gender) {
    switch (gender) {
      case 'Ami':
        return Icons.water;
      case 'Amom':
        return Icons.android;
      case 'Amo':
      default:
        return Icons.diamond;
    }
  }

  /// Returns the [TextStyle] for a gender string.
  static TextStyle getGenderTextStyle(String gender) {
    switch (gender) {
      case 'Ami':
        return const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF9E9E9E),
        );
      case 'Amom':
        return const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFD54F),
        );
      case 'Amo':
      default:
        return const TextStyle(
          letterSpacing: 1.5,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFFB388FF),
        );
    }
  }

  /// Returns the default content [TextStyle] for feed cards.
  static const TextStyle defaultContentTextStyle = TextStyle(
    fontSize: 14,
    height: 1.4,
  );
}
