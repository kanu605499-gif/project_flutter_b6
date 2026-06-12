import '../models/report_model.dart';
import '../models/user_indicator_model.dart';

/// Calculates and manages the benevolent points system.
///
/// **Benevolent Points** (0–100 percentage scale):
/// - Points INCREASE when a user is reported (bad behavior).
/// - Points DECREASE when a user receives resonates (redemption).
/// - 0–49  → CLOUDY (grey, neutral user)
/// - 50–79 → GHOST (yellow, amoral / nonchalant user)
/// - 80–100 → NOISE (purple, flagged / toxic user)
///
/// **Point weights:**
/// - Each report adds points based on its category severity.
/// - Each resonate received subtracts a small amount.
/// - Chat behavior reports (per-bubble) carry higher weight.
class BenevolentCalculator {
  BenevolentCalculator._(); // prevent instantiation

  // ── Report weights (points ADDED per report) ──────────

  /// Base weight for a general (user-level) report.
  static const int baseReportWeight = 16;

  /// Extra weight when the report is a per-chat-bubble report.
  /// Chat behavior reports are weighted higher as requested.
  static const int chatBubbleBonus = 4;

  /// Severity multipliers per report category.
  static const Map<ReportCategory, double> categoryMultipliers = {
    ReportCategory.spamHarassment: 1.0, // 8 pts (base)
    ReportCategory.inappropriateContent: 1.25, // 10 pts (base)
    ReportCategory.hateSpeech: 1.5, // 12 pts (base)
  };

  // ── Resonate weights (points SUBTRACTED per resonate) ──

  /// How many benevolent points are reduced per resonate received.
  static const int resonateReduction = 1;

  // ── Calculation ────────────────────────────────────────

  /// Calculates the benevolent points from a list of reports against the user
  /// and the number of resonates the user has received.
  ///
  /// Returns a value clamped between 0 and 100.
  static int calculate({
    required List<ReportModel> reportsAgainstUser,
    required int totalResonatesReceived,
  }) {
    // Sum up report points
    double reportPoints = 0;
    for (final report in reportsAgainstUser) {
      final multiplier = categoryMultipliers[report.category] ?? 1.0;
      final base = baseReportWeight * multiplier;
      final bonus = report.isChatBubbleReport ? chatBubbleBonus : 0;
      reportPoints += base + bonus;
    }

    // Subtract resonate redemption
    final resonateRedemption = totalResonatesReceived * resonateReduction;

    final rawScore = reportPoints - resonateRedemption;
    return rawScore.round().clamp(0, 100);
  }

  /// Calculates benevolent points and returns the corresponding [UserIndicator].
  ///
  /// If the user's current indicator is NOISE (admin-assigned), it is preserved
  /// regardless of the calculated score.
  static UserIndicator calculateIndicator({
    required List<ReportModel> reportsAgainstUser,
    required int totalResonatesReceived,
    required String currentIndicator,
  }) {

    final points = calculate(
      reportsAgainstUser: reportsAgainstUser,
      totalResonatesReceived: totalResonatesReceived,
    );

    return UserIndicatorHelper.fromBenevolentPoints(points);
  }

  /// Convenience: returns both the calculated points and the indicator.
  static ({int points, UserIndicator indicator}) evaluateUser({
    required List<ReportModel> reportsAgainstUser,
    required int totalResonatesReceived,
    required String currentIndicator,
  }) {

    final points = calculate(
      reportsAgainstUser: reportsAgainstUser,
      totalResonatesReceived: totalResonatesReceived,
    );

    return (
      points: points,
      indicator: UserIndicatorHelper.fromBenevolentPoints(points),
    );
  }

  /// Adds a single report's points directly.
  static ({int points, UserIndicator indicator}) addReportToUser({
    required int currentPoints,
    required ReportCategory category,
    required bool isChatBubbleReport,
    required String currentIndicator,
  }) {

    final multiplier = categoryMultipliers[category] ?? 1.0;
    final base = baseReportWeight * multiplier;
    final bonus = isChatBubbleReport ? chatBubbleBonus : 0;

    final int newPoints = (currentPoints + (base + bonus).round()).clamp(
      0,
      100,
    );
    return (
      points: newPoints,
      indicator: UserIndicatorHelper.fromBenevolentPoints(newPoints),
    );
  }
}
