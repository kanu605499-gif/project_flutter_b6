import '../models/user_model.dart';

/// Consolidated seed/dummy data for first-launch experiences.
///
/// Moved from [DatabaseHelper._seedDummiesIfNeeded] to keep
/// the data layer separate from persistence logic.
class SeedData {
  SeedData._(); // prevent instantiation

  /// The 10 dummy accounts used to populate the initial user list.
  static List<UserAccount> generateDummyAccounts() {
    return [
      UserAccount(
        email: "spectral@amomimus.com",
        realUsername: "Spectral Root",
        anonymousUsername: "Silent Phantom",
        amomimusId: "#AMM-0001",
        gender: "Amo",
        registrationDate: DateTime.now()
            .subtract(const Duration(days: 90))
            .toIso8601String(),
        isDemo: true,
      ),
      UserAccount(
        email: "twi@amomimus.com",
        realUsername: "Twilight Engine",
        anonymousUsername: "Crystal Mist",
        amomimusId: "#AMM-0002",
        gender: "Ami",
        registrationDate: DateTime.now()
            .subtract(const Duration(days: 85))
            .toIso8601String(),
        isDemo: true,
      ),
      UserAccount(
        email: "cipher@amomimus.com",
        realUsername: "Cipher Forge",
        anonymousUsername: "Golden Cipher",
        amomimusId: "#AMM-0003",
        gender: "Amom",
        registrationDate: DateTime.now()
            .subtract(const Duration(days: 80))
            .toIso8601String(),
        isDemo: true,
      ),
      UserAccount(
        email: "v0id@amomimus.com",
        realUsername: "Void Walker",
        anonymousUsername: "Void Drifter",
        amomimusId: "#AMM-0004",
        gender: "Amo",
        registrationDate: DateTime.now()
            .subtract(const Duration(days: 70))
            .toIso8601String(),
        isDemo: true,
      ),
      UserAccount(
        email: "velvet@amomimus.com",
        realUsername: "Velvet Arc",
        anonymousUsername: "Velvet Shadow",
        amomimusId: "#AMM-0005",
        gender: "Ami",
        registrationDate: DateTime.now()
            .subtract(const Duration(days: 65))
            .toIso8601String(),
        isDemo: true,
      ),
      UserAccount(
        email: "titanfall@amomimus.com",
        realUsername: "Titan Spec",
        anonymousUsername: "Titan Shade",
        amomimusId: "#AMM-0006",
        gender: "Amom",
        registrationDate: DateTime.now()
            .subtract(const Duration(days: 60))
            .toIso8601String(),
        isDemo: true,
      ),
      UserAccount(
        email: "ember@amomimus.com",
        realUsername: "Night Ember",
        anonymousUsername: "Night Ember",
        amomimusId: "#AMM-0007",
        gender: "Amo",
        registrationDate: DateTime.now()
            .subtract(const Duration(days: 55))
            .toIso8601String(),
        isDemo: true,
      ),
      UserAccount(
        email: "pearl@amomimus.com",
        realUsername: "Pearl Dawn",
        anonymousUsername: "Pearl Cascade",
        amomimusId: "#AMM-0008",
        gender: "Ami",
        registrationDate: DateTime.now()
            .subtract(const Duration(days: 50))
            .toIso8601String(),
        isDemo: true,
      ),
      UserAccount(
        email: "cobalt@amomimus.com",
        realUsername: "Cobalt System",
        anonymousUsername: "Cobalt Echo",
        amomimusId: "#AMM-0009",
        gender: "Amom",
        registrationDate: DateTime.now()
            .subtract(const Duration(days: 45))
            .toIso8601String(),
        isDemo: true,
      ),
      UserAccount(
        email: "aurora@amomimus.com",
        realUsername: "Aurora Vex",
        anonymousUsername: "Aurora Shade",
        amomimusId: "#AMM-0010",
        gender: "Ami",
        registrationDate: DateTime.now()
            .subtract(const Duration(days: 40))
            .toIso8601String(),
        isDemo: true,
      ),
    ];
  }
}
