/// User account model for the Amomimus app.
///
/// Firestore-ready with [fromMap] / [toMap] support.
class UserAccount {
  final int? id;
  final String email;
  final String realUsername;
  final String anonymousUsername;
  final String? customUsername;
  final String amomimusId;
  final String gender;
  final String registrationDate;
  final bool isDemo;
  final String bio;
  final int coins;
  final int reportedCount;
  final String? lastRedeemed;
  final int dailyChatRequestsSent;
  final String? lastChatRequestDate;

  // Extended fields
  final String? dateOfBirth;
  final int totalResonatesReceived;
  final List<String> ownedStickers;
  final List<String> blockedUsers;
  final List<String> hiddenFeeds;

  // Indicator system fields
  final int benevolentPoints;    // 0–100 (percentage); 1–75 = CLOUDY, 76–100 = GHOST
  final String indicator;        // 'cloudy', 'ghost', or 'noise' (noise = admin-only)

  UserAccount({
    this.id,
    required this.email,
    required this.realUsername,
    required this.anonymousUsername,
    this.customUsername,
    required this.amomimusId,
    required this.gender,
    required this.registrationDate,
    required this.isDemo,
    this.bio = "No bio yet",
    this.coins = 1240,
    this.reportedCount = 0,
    this.lastRedeemed,
    this.dailyChatRequestsSent = 0,
    this.lastChatRequestDate,
    this.dateOfBirth,
    this.totalResonatesReceived = 0,
    this.ownedStickers = const [],
    this.blockedUsers = const [],
    this.hiddenFeeds = const [],
    this.benevolentPoints = 0,
    this.indicator = 'cloudy',
  });

  /// Firestore-ready: creates a [UserAccount] from a [Map].
  factory UserAccount.fromMap(Map<String, dynamic> map) {
    return UserAccount(
      id: map['id'],
      email: map['email'],
      realUsername: map['realUsername'],
      anonymousUsername: map['anonymousUsername'],
      customUsername: map['customUsername'],
      amomimusId: map['amomimusId'],
      gender: map['gender'],
      registrationDate: map['registrationDate'],
      isDemo: map['isDemo'] == 1 || map['isDemo'] == true,
      bio: map['bio'] ?? "No bio yet",
      coins: map['coins'] ?? 1240,
      reportedCount: map['reportedCount'] ?? 0,
      lastRedeemed: map['lastRedeemed'],
      dailyChatRequestsSent: map['dailyChatRequestsSent'] ?? 0,
      lastChatRequestDate: map['lastChatRequestDate'],
      dateOfBirth: map['dateOfBirth'],
      totalResonatesReceived: map['totalResonatesReceived'] ?? 0,
      ownedStickers: (map['ownedStickers'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      blockedUsers: (map['blockedUsers'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      hiddenFeeds: (map['hiddenFeeds'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      benevolentPoints: map['benevolentPoints'] ?? 0,
      indicator: map['indicator'] ?? 'cloudy',
    );
  }

  /// Firestore-ready: converts this [UserAccount] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'realUsername': realUsername,
      'anonymousUsername': anonymousUsername,
      'customUsername': customUsername,
      'amomimusId': amomimusId,
      'gender': gender,
      'registrationDate': registrationDate,
      'isDemo': isDemo ? 1 : 0,
      'bio': bio,
      'coins': coins,
      'reportedCount': reportedCount,
      'lastRedeemed': lastRedeemed,
      'dailyChatRequestsSent': dailyChatRequestsSent,
      'lastChatRequestDate': lastChatRequestDate,
      'dateOfBirth': dateOfBirth,
      'totalResonatesReceived': totalResonatesReceived,
      'ownedStickers': ownedStickers,
      'blockedUsers': blockedUsers,
      'hiddenFeeds': hiddenFeeds,
      'benevolentPoints': benevolentPoints,
      'indicator': indicator,
    };
  }

  UserAccount copyWith({
    int? id,
    String? email,
    String? realUsername,
    String? anonymousUsername,
    String? customUsername,
    String? amomimusId,
    String? gender,
    String? registrationDate,
    bool? isDemo,
    String? bio,
    int? coins,
    int? reportedCount,
    String? lastRedeemed,
    int? dailyChatRequestsSent,
    String? lastChatRequestDate,
    String? dateOfBirth,
    int? totalResonatesReceived,
    List<String>? ownedStickers,
    List<String>? blockedUsers,
    List<String>? hiddenFeeds,
    int? benevolentPoints,
    String? indicator,
  }) {
    return UserAccount(
      id: id ?? this.id,
      email: email ?? this.email,
      realUsername: realUsername ?? this.realUsername,
      anonymousUsername: anonymousUsername ?? this.anonymousUsername,
      customUsername: customUsername ?? this.customUsername,
      amomimusId: amomimusId ?? this.amomimusId,
      gender: gender ?? this.gender,
      registrationDate: registrationDate ?? this.registrationDate,
      isDemo: isDemo ?? this.isDemo,
      bio: bio ?? this.bio,
      coins: coins ?? this.coins,
      reportedCount: reportedCount ?? this.reportedCount,
      lastRedeemed: lastRedeemed ?? this.lastRedeemed,
      dailyChatRequestsSent:
          dailyChatRequestsSent ?? this.dailyChatRequestsSent,
      lastChatRequestDate: lastChatRequestDate ?? this.lastChatRequestDate,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      totalResonatesReceived:
          totalResonatesReceived ?? this.totalResonatesReceived,
      ownedStickers: ownedStickers ?? this.ownedStickers,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      hiddenFeeds: hiddenFeeds ?? this.hiddenFeeds,
      benevolentPoints: benevolentPoints ?? this.benevolentPoints,
      indicator: indicator ?? this.indicator,
    );
  }

  /// A fallback empty [UserAccount] for UI contexts where no real user is available.
  static UserAccount empty() {
    return UserAccount(
      email: '',
      realUsername: '',
      anonymousUsername: '',
      amomimusId: '',
      gender: 'Amo',
      registrationDate: '',
      isDemo: false,
    );
  }
}
