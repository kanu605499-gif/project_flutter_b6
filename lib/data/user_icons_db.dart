import 'package:flutter/material.dart';
import '../models/user_icon_model.dart';

/// Database of selectable user avatar icons for each Amomimus gender type.
///
/// Each type has 10 icons curated to match its personality:
/// - **Amo** 💎 — Mysterious, cosmic, elegant, dark energy
/// - **Ami** 🌊 — Gentle, nature, serene, soft presence
/// - **Amom** 🤖 — Techy, digital, mechanical, futuristic
class UserIconsDB {
  UserIconsDB._(); // prevent instantiation

  // ─────────────────────────────────────────────
  // AMO — Mysterious, cosmic, elegant, dark energy
  // ─────────────────────────────────────────────
  static const List<UserIconModel> amoIcons = [
    UserIconModel(
      id: 'amo_icon_01',
      name: 'Diamond',
      gender: 'Amo',
      iconCodePoint: 0xf04ed, // Icons.diamond
    ),
    UserIconModel(
      id: 'amo_icon_02',
      name: 'Dark Mode',
      gender: 'Amo',
      iconCodePoint: 0xe1b0, // Icons.dark_mode
    ),
    UserIconModel(
      id: 'amo_icon_03',
      name: 'Nightlight',
      gender: 'Amo',
      iconCodePoint: 0xe42f, // Icons.nightlight_round
    ),
    UserIconModel(
      id: 'amo_icon_04',
      name: 'Bolt',
      gender: 'Amo',
      iconCodePoint: 0xe0ee, // Icons.bolt
    ),
    UserIconModel(
      id: 'amo_icon_05',
      name: 'Whatshot',
      gender: 'Amo',
      iconCodePoint: 0xe6e3, // Icons.whatshot
    ),
    UserIconModel(
      id: 'amo_icon_06',
      name: 'Auto Awesome',
      gender: 'Amo',
      iconCodePoint: 0xe0b7, // Icons.auto_awesome
    ),
    UserIconModel(
      id: 'amo_icon_07',
      name: 'Visibility Off',
      gender: 'Amo',
      iconCodePoint: 0xe6be, // Icons.visibility_off
    ),
    UserIconModel(
      id: 'amo_icon_08',
      name: 'Shield Moon',
      gender: 'Amo',
      iconCodePoint: 0xf0566, // Icons.shield_moon
    ),
    UserIconModel(
      id: 'amo_icon_09',
      name: 'Flare',
      gender: 'Amo',
      iconCodePoint: 0xe290, // Icons.flare
    ),
    UserIconModel(
      id: 'amo_icon_10',
      name: 'Mysterious Face',
      gender: 'Amo',
      iconCodePoint: 0xf0863, // Icons.face_6
    ),
  ];

  // ─────────────────────────────────────────────
  // AMI — Gentle, nature, serene, soft presence
  // ─────────────────────────────────────────────
  static const List<UserIconModel> amiIcons = [
    UserIconModel(
      id: 'ami_icon_01',
      name: 'Water Drop',
      gender: 'Ami',
      iconCodePoint: 0xf05a2, // Icons.water_drop
    ),
    UserIconModel(
      id: 'ami_icon_02',
      name: 'Spa',
      gender: 'Ami',
      iconCodePoint: 0xe5d8, // Icons.spa
    ),
    UserIconModel(
      id: 'ami_icon_03',
      name: 'Florist',
      gender: 'Ami',
      iconCodePoint: 0xe393, // Icons.local_florist
    ),
    UserIconModel(
      id: 'ami_icon_04',
      name: 'Eco',
      gender: 'Ami',
      iconCodePoint: 0xe217, // Icons.eco
    ),
    UserIconModel(
      id: 'ami_icon_05',
      name: 'Favorite',
      gender: 'Ami',
      iconCodePoint: 0xe25b, // Icons.favorite
    ),
    UserIconModel(
      id: 'ami_icon_06',
      name: 'Bunny',
      gender: 'Ami',
      iconCodePoint: 0xf04da, // Icons.cruelty_free
    ),
    UserIconModel(
      id: 'ami_icon_07',
      name: 'Cloud',
      gender: 'Ami',
      iconCodePoint: 0xe16f, // Icons.cloud
    ),
    UserIconModel(
      id: 'ami_icon_08',
      name: 'Snowflake',
      gender: 'Ami',
      iconCodePoint: 0xe037, // Icons.ac_unit
    ),
    UserIconModel(
      id: 'ami_icon_09',
      name: 'Meditation',
      gender: 'Ami',
      iconCodePoint: 0xe56f, // Icons.self_improvement
    ),
    UserIconModel(
      id: 'ami_icon_10',
      name: 'Soft Glow',
      gender: 'Ami',
      iconCodePoint: 0xe10e, // Icons.brightness_low
    ),
  ];

  // ─────────────────────────────────────────────
  // AMOM — Techy, digital, mechanical, futuristic
  // ─────────────────────────────────────────────
  static const List<UserIconModel> amomIcons = [
    UserIconModel(
      id: 'amom_icon_01',
      name: 'Android',
      gender: 'Amom',
      iconCodePoint: 0xe085, // Icons.android
    ),
    UserIconModel(
      id: 'amom_icon_02',
      name: 'Terminal',
      gender: 'Amom',
      iconCodePoint: 0xf0589, // Icons.terminal
    ),
    UserIconModel(
      id: 'amom_icon_03',
      name: 'Memory Chip',
      gender: 'Amom',
      iconCodePoint: 0xe3db, // Icons.memory
    ),
    UserIconModel(
      id: 'amom_icon_04',
      name: 'Robot',
      gender: 'Amom',
      iconCodePoint: 0xe5c5, // Icons.smart_toy
    ),
    UserIconModel(
      id: 'amom_icon_05',
      name: 'Gear Sparkle',
      gender: 'Amom',
      iconCodePoint: 0xe590, // Icons.settings_suggest
    ),
    UserIconModel(
      id: 'amom_icon_06',
      name: 'Code',
      gender: 'Amom',
      iconCodePoint: 0xe176, // Icons.code
    ),
    UserIconModel(
      id: 'amom_icon_07',
      name: 'Dev Board',
      gender: 'Amom',
      iconCodePoint: 0xe1c5, // Icons.developer_board
    ),
    UserIconModel(
      id: 'amom_icon_08',
      name: 'Rocket',
      gender: 'Amom',
      iconCodePoint: 0xf055d, // Icons.rocket_launch
    ),
    UserIconModel(
      id: 'amom_icon_09',
      name: 'Network Hub',
      gender: 'Amom',
      iconCodePoint: 0xf051d, // Icons.hub
    ),
    UserIconModel(
      id: 'amom_icon_10',
      name: 'Brain Gear',
      gender: 'Amom',
      iconCodePoint: 0xe4ef, // Icons.psychology
    ),
  ];

  /// Returns all icons combined across all genders.
  static List<UserIconModel> get allIcons => [
        ...amoIcons,
        ...amiIcons,
        ...amomIcons,
      ];

  /// Returns the list of icons for a given [gender] string ('Amo', 'Ami', 'Amom').
  static List<UserIconModel> getIconsByGender(String gender) {
    switch (gender) {
      case 'Ami':
        return amiIcons;
      case 'Amom':
        return amomIcons;
      case 'Amo':
      default:
        return amoIcons;
    }
  }

  /// Finds a specific icon by its [id]. Returns null if not found.
  static UserIconModel? getIconById(String id) {
    try {
      return allIcons.firstWhere((icon) => icon.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Returns the default icon for a given [gender].
  static UserIconModel getDefaultIcon(String gender) {
    switch (gender) {
      case 'Ami':
        return amiIcons.first; // Water Drop
      case 'Amom':
        return amomIcons.first; // Android
      case 'Amo':
      default:
        return amoIcons.first; // Diamond
    }
  }

  /// Resolves a [UserIconModel] into an [IconData] for rendering.
  static IconData toIconData(UserIconModel icon) {
    return IconData(icon.iconCodePoint, fontFamily: icon.iconFontFamily);
  }
}
