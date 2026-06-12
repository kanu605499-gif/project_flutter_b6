import 'dart:math';
import 'package:flutter/material.dart';

/// Pool of anonymous name lists used throughout the Amomimus app.
///
/// Centralizes all hardcoded name data that was previously scattered
/// inside [FeedModel] and other locations.
class AnonymousNames {
  AnonymousNames._(); // prevent instantiation

  static final List<String> amoNames = [
    "Silent Phantom",
    "Void Drifter",
    "Night Ember",
    "Shadow Pulse",
    "Dark Mirage",
    "Ash Reverie",
    "Obsidian Ghost",
    "Lunar Veil",
    "Crimson Haunt",
    "Neon Specter",
  ];

  static final List<String> amiNames = [
    "Crystal Mist",
    "Twilight Bloom",
    "Velvet Shadow",
    "Ivory Whisper",
    "Sapphire Dream",
    "Silver Lining",
    "Moonlit Rose",
    "Pearl Cascade",
    "Aurora Shade",
    "Lilac Phantom",
  ];

  static final List<String> amomNames = [
    "Golden Cipher",
    "Iron Whisper",
    "Bronze Nomad",
    "Titan Shade",
    "Copper Drift",
    "Steel Mirage",
    "Amber Ghost",
    "Platinum Veil",
    "Cobalt Echo",
    "Rustic Phantom",
  ];

  /// Returns a random anonymous name from the pool matching the given [gender].
  static String getRandomName(String gender) {
    final random = Random();
    switch (gender) {
      case 'Ami':
        return amiNames[random.nextInt(amiNames.length)];
      case 'Amom':
        return amomNames[random.nextInt(amomNames.length)];
      case 'Amo':
      default:
        return amoNames[random.nextInt(amoNames.length)];
    }
  }

  static const List<IconData> _icons = [
    Icons.diamond,
    Icons.android,
    Icons.water,
    Icons.star,
    Icons.person_outline,
    Icons.favorite,
    Icons.brightness_high,
    Icons.local_fire_department,
    Icons.auto_awesome,
  ];

  static const List<int> _colors = [
    0xFFE53935, // Colors.red.shade600
    0xFF1E88E5, // Colors.blue.shade600
    0xFF43A047, // Colors.green.shade600
    0xFFFB8C00, // Colors.orange.shade600
    0xFF8E24AA, // Colors.purple.shade600
    0xFF00ACC1, // Colors.cyan.shade600
    0xFFFDD835, // Colors.yellow.shade600
    0xFFD81B60, // Colors.pink.shade600
  ];

  /// Generates a consistent random name for a specific user on a specific post
  static String getConsistentNameForPost(String userId, String postId) {
    final seed = (userId + postId).hashCode;
    final random = Random(seed);
    final allNames = [...amoNames, ...amiNames, ...amomNames];
    return allNames[random.nextInt(allNames.length)];
  }

  /// Generates a consistent icon for a specific user on a specific post
  static IconData getConsistentIconForPost(String userId, String postId) {
    final seed = (userId + postId).hashCode;
    final random = Random(seed);
    return _icons[random.nextInt(_icons.length)];
  }

  /// Generates a consistent color for a specific user on a specific post
  static int getConsistentColorForPost(String userId, String postId) {
    final seed = (userId + postId).hashCode;
    final random = Random(seed);
    return _colors[random.nextInt(_colors.length)];
  }
}
