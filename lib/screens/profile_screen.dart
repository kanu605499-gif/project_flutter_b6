import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/account_manager.dart';
import '../amomimusdark.dart';
import '../services/feed_manager.dart';
import '../models/post_model.dart';
import '../services/chat_request_manager.dart';
import '../services/chatmodel.dart';
import '../helpers/gender_helpers.dart';
import '../widgets/report_dialog.dart';
import '../models/user_indicator_model.dart';
import '../models/user_model.dart';
import '../language/language_manager.dart';

class ProfileScreen extends StatefulWidget {
  final String? targetUserId;
  final FeedModel? feedModel;

  const ProfileScreen({super.key, this.targetUserId, this.feedModel});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _bubbleController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  final PageController _pageController = PageController();
  final TextEditingController _bioController = TextEditingController();
  bool _bioChanged = false;
  bool _bioInitialized = false;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _fabAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _bubbleController.dispose();
    _fabAnimationController.dispose();
    _pageController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Widget _buildTopSection(
    BuildContext context,
    dynamic user,
    bool isDark,
    bool isOtherUser,
    bool isLocked,
  ) {
    Color iconColor = GenderHelpers.getGenderColor(user.gender);
    IconData icon = GenderHelpers.getGenderIcon(user.gender);

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: iconColor, width: 2),
              ),
              child: Center(child: Icon(icon, size: 50, color: iconColor)),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.green, // Active indicator
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? AmomimusDarkTheme.backgroundDark
                      : Colors.white,
                  width: 3,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          isLocked
              ? user.amomimusId
              : (!isOtherUser &&
                      user.customUsername != null &&
                      user.customUsername!.isNotEmpty)
                  ? user.customUsername!
                  : user.anonymousUsername,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark
                ? AmomimusDarkTheme.policeLineYellow
                : AmomimusDarkTheme.primaryPurple,
          ),
        ),
        if (!isLocked && !isOtherUser &&
            user.customUsername != null &&
            user.customUsername!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            "${context.watch<LanguageManager>().getString('public_name')}: ${user.anonymousUsername}",
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
        if (!isLocked) ...[
          const SizedBox(height: 4),
          Text(
            user.amomimusId,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBioAndCoinsSection(
    BuildContext context,
    dynamic user,
    bool isDark,
    bool isOtherUser,
  ) {
    if (isOtherUser) {
      // If viewing another user's profile, only show their bio
      return SizedBox(
        height: 140,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: Provider.of<AmomimusDarkTheme>(context).cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 18,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.watch<LanguageManager>().getString('bio'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                user.bio.isEmpty ? context.watch<LanguageManager>().getString('no_bio_yet') : user.bio,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 140,
      child: PageView(
        controller: _pageController,
        children: [
          // Bio Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: Provider.of<AmomimusDarkTheme>(context).cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 18,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.watch<LanguageManager>().getString('bio'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _bioController,
                          maxLines: 2,
                          maxLength: 80,
                          onChanged: (val) {
                            if (!_bioChanged) {
                              setState(() => _bioChanged = true);
                            }
                          },
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: context.watch<LanguageManager>().getString('write_bio'),
                            hintStyle: TextStyle(
                              color: isDark
                                  ? Colors.grey[600]
                                  : Colors.grey[400],
                            ),
                            counterText: '',
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      if (_bioChanged)
                        GestureDetector(
                          onTap: () async {
                            final text = _bioController.text.trim();
                            if (text.isEmpty) return;
                            await Provider.of<AccountManager>(
                              context,
                              listen: false,
                            ).updateBio(text);
                            setState(() => _bioChanged = false);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.read<LanguageManager>().getString('bio_updated')),
                                  backgroundColor: isDark
                                      ? AmomimusDarkTheme.policeLineYellow
                                      : AmomimusDarkTheme.primaryPurple,
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.send_rounded,
                              size: 22,
                              color: isDark
                                  ? AmomimusDarkTheme.policeLineYellow
                                  : AmomimusDarkTheme.primaryPurple,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const Spacer(),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xff8c72c4),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Coins Redemption Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AmomimusDarkTheme.surfaceDark : const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AmomimusDarkTheme.policeLineYellow.withOpacity(0.5) : Colors.amber.shade300,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? AmomimusDarkTheme.policeLineYellow.withOpacity(0.1)
                      : Colors.amber.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      size: 18,
                      color: isDark ? AmomimusDarkTheme.policeLineYellow : Colors.amber.shade800,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.watch<LanguageManager>().getString('coins_redemption'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AmomimusDarkTheme.policeLineYellow : Colors.amber.shade900,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Builder(
                  builder: (context) {
                    bool canRedeem = true;
                    String countdownText = "";

                    if (user.lastRedeemed != null) {
                      final lastRedeemedDate = DateTime.tryParse(
                        user.lastRedeemed!,
                      );
                      if (lastRedeemedDate != null) {
                        final difference = DateTime.now().difference(
                          lastRedeemedDate,
                        );
                        final remaining =
                            const Duration(minutes: 30) - difference;

                        if (remaining.inSeconds > 0) {
                          canRedeem = false;
                          final m = remaining.inMinutes.toString().padLeft(
                            2,
                            '0',
                          );
                          final s = (remaining.inSeconds % 60)
                              .toString()
                              .padLeft(2, '0');
                          countdownText = "$m:$s";
                        }
                      }
                    }

                    return GestureDetector(
                      onTap: canRedeem
                          ? () async {
                              await Provider.of<AccountManager>(
                                context,
                                listen: false,
                              ).updateCoins(100, updateTimestamp: true);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(context.read<LanguageManager>().getString('redeemed_100_coins')),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            }
                          : null,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: canRedeem
                              ? const Color(0xFFFFD54F)
                              : Colors.grey[400],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: canRedeem
                              ? const Icon(
                                  Icons.monetization_on,
                                  color: Colors.white,
                                  size: 28,
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      countdownText,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xff8c72c4),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaultAndMeritSection(
    BuildContext context,
    dynamic user,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.watch<LanguageManager>().getString('vault_merit'),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AmomimusDarkTheme.policeLineYellow
                  : AmomimusDarkTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: Provider.of<AmomimusDarkTheme>(context)
                        .cardDecoration
                        .copyWith(
                          border: Border.all(
                            color: const Color(0xFFFFD54F),
                            width: 1.5,
                          ),
                        ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          color: Color(0xFFFFD54F),
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          context.watch<LanguageManager>().getString('my_coins'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.coins.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AmomimusDarkTheme.policeLineYellow,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: Provider.of<AmomimusDarkTheme>(context)
                        .cardDecoration
                        .copyWith(
                          border: Border.all(
                            color: const Color(0xff8c72c4),
                            width: 1.5,
                          ),
                        ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.card_giftcard,
                          color: Color(0xff8c72c4),
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          context.watch<LanguageManager>().getString('owned'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context.watch<LanguageManager>().getString('sticker_stash'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AmomimusDarkTheme.primaryPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorCard(BuildContext context, dynamic user, bool isDark) {
    UserIndicator indicator = UserIndicatorHelper.fromValue(user.indicator);
    String indicatorLabel = UserIndicatorHelper.getLabel(indicator);
    Color indicatorColor = UserIndicatorHelper.getColor(indicator);

    Color iconColor = GenderHelpers.getGenderColor(user.gender);
    IconData userIcon = GenderHelpers.getGenderIcon(user.gender);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 120,
      decoration: Provider.of<AmomimusDarkTheme>(context).cardDecoration
          .copyWith(border: Border.all(color: indicatorColor, width: 2)),
      child: Stack(
        children: [
          // Background floating particles
          AnimatedBuilder(
            animation: _bubbleController,
            builder: (context, child) {
              final val = _bubbleController.value;
              return Stack(
                children: List.generate(20, (index) {
                  // Pseudo-random deterministic values based on index
                  final double startX = (index * 57.0) % 350;
                  final double startY = (index * 41.0) % 120;
                  final double size = 6.0 + (index % 10);

                  // Move bottom to top using modulo to wrap around seamlessly
                  final double yPos = (startY - (val * 120)) % 120;
                  // Subtle sway on the X axis
                  final double xPos = startX + (sin(val * pi * 4 + index) * 10);

                  return Positioned(
                    left: xPos,
                    top: yPos < 0
                        ? yPos + 120
                        : yPos, // Handle negative modulo in dart
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: indicatorColor.withOpacity(
                          0.1 + (index % 3) * 0.05,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.watch<LanguageManager>().getString('amomimus_indicators'),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      indicatorLabel,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3.0,
                        color:
                            indicatorColor == const Color(0xffE0E0E0) && !isDark
                            ? Colors.grey[600]
                            : indicatorColor,
                      ),
                    ),
                  ],
                ),
                Icon(userIcon, size: 36, color: iconColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentResonates(
    BuildContext context,
    dynamic user,
    bool isDark,
    bool isOtherUser,
  ) {
    final feedManager = Provider.of<FeedManager>(context);
    // userFeeds filters the active user's feeds.
    // If it's another user, we filter to show only feeds created within the last 24h.
    final userFeeds = feedManager.feeds.where((f) {
      if (f.realAuthorId != user.amomimusId) return false;
      if (isOtherUser) {
        if (f.createdAt != null) {
          final createdAt = DateTime.tryParse(f.createdAt!);
          if (createdAt != null) {
            if (DateTime.now().difference(createdAt).inHours > 24) return false;
          }
        } else {
          return false;
        }
      }
      return true;
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.watch<LanguageManager>().getString('recent_resonates'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AmomimusDarkTheme.policeLineYellow
                        : AmomimusDarkTheme.primaryPurple,
                  ),
                ),
                TextButton(
                  onPressed: () => _showAllResonatesSheet(
                    context,
                    userFeeds,
                    isDark,
                    isOtherUser,
                  ),
                  child: Text(
                    context.watch<LanguageManager>().getString('see_all'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AmomimusDarkTheme.policeLineYellow
                          : AmomimusDarkTheme.primaryPurple,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (userFeeds.isEmpty)
            Text(
              context.watch<LanguageManager>().getString('no_recent_resonates'),
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            )
          else
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: min(3, userFeeds.length),
                itemBuilder: (context, index) {
                  final feed = userFeeds[index];
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: Provider.of<AmomimusDarkTheme>(
                      context,
                    ).cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '"${feed.content}"',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          feed.timeStamp,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showAllResonatesSheet(
    BuildContext context,
    List<FeedModel> userFeeds,
    bool isDark,
    bool isOtherUser,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AmomimusDarkTheme.backgroundDark : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.watch<LanguageManager>().getString('all_resonates'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xffb388ff),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: userFeeds.isEmpty
                        ? Center(
                            child: Text(
                              context.watch<LanguageManager>().getString('no_resonates_yet'),
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: userFeeds.length,
                            itemBuilder: (context, index) {
                              final feed = userFeeds[index];
                              return GestureDetector(
                                onLongPress: () {
                                  if (!isOtherUser) {
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) => AlertDialog(
                                        backgroundColor: isDark
                                            ? AmomimusDarkTheme.surfaceDark
                                            : Colors.white,
                                        surfaceTintColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        title: Row(
                                          children: [
                                            Icon(
                                              Icons.delete_outline,
                                              color: Colors.redAccent,
                                              size: 24,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              context.read<LanguageManager>().getString('delete_post_title'),
                                              style: TextStyle(
                                                color: isDark
                                                    ? AmomimusDarkTheme
                                                          .policeLineYellow
                                                    : const Color(0xff684ca3),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                        content: Text(
                                          context.read<LanguageManager>().getString('delete_post_confirm'),
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.black87,
                                            fontSize: 14,
                                            height: 1.5,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(dialogContext),
                                            child: Text(
                                              context.read<LanguageManager>().getString('cancel'),
                                              style: TextStyle(
                                                color: isDark
                                                    ? Colors.grey[400]
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Provider.of<FeedManager>(
                                                context,
                                                listen: false,
                                              ).deletePostById(feed.id);
                                              Navigator.pop(dialogContext);
                                              Navigator.pop(
                                                context,
                                              ); // Close sheet
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: Text(
                                              context.read<LanguageManager>().getString('delete'),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: Provider.of<AmomimusDarkTheme>(
                                    context,
                                  ).cardDecoration,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        feed.content,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            feed.timeStamp,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isDark
                                                  ? Colors.grey[400]
                                                  : Colors.grey[500],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.favorite_border,
                                                size: 14,
                                                color: isDark
                                                    ? Colors.grey[400]
                                                    : Colors.grey[600],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                feed.resonatedBy.length
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isDark
                                                      ? Colors.grey[400]
                                                      : Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLockedSection(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(40),
      decoration: Provider.of<AmomimusDarkTheme>(context).cardDecoration
          .copyWith(
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.black12,
              width: 2,
            ),
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 64,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            context.watch<LanguageManager>().getString('profile_locked'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.watch<LanguageManager>().getString('locked_desc'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AmomimusDarkTheme>(context).isDarkMode;
    final accountManager = Provider.of<AccountManager>(context);
    final reqManager = Provider.of<ChatRequestManager>(context);
    final chatModel = Provider.of<ChatModel>(context);

    dynamic user = accountManager.currentUser;
    bool isOtherUser = false;
    bool isLocked = false;

    if (widget.targetUserId != null &&
        widget.targetUserId != accountManager.currentUser?.amomimusId) {
      isOtherUser = true;

      // Check if locked
      if (!reqManager.isChatAllowed(widget.targetUserId!) &&
          chatModel.getChatByUsername(widget.targetUserId!).messages.isEmpty) {
        isLocked = true;
      }

      String normalizedTargetId = widget.targetUserId!;
      final match = RegExp(r'#(?:YOU|AMO|AMI|AMOM)-(\d+)').firstMatch(widget.targetUserId!);
      if (match != null) {
        int num = int.parse(match.group(1)!);
        if (num == 100) num = 110;
        normalizedTargetId = '#AMM-$num';
      } else {
        normalizedTargetId = widget.targetUserId!.replaceAll(RegExp(r'#AM[OMI]+-'), '#AMM-');
      }

      try {
        user = accountManager.accounts.firstWhere(
          (acc) => acc.amomimusId == widget.targetUserId || acc.amomimusId == normalizedTargetId,
        );
      } catch (e) {
        if (widget.feedModel != null) {
          String gender = "Amo";
          if (widget.feedModel!.type == AccountType.ami) gender = "Ami";
          if (widget.feedModel!.type == AccountType.amom) gender = "Amom";
          user = UserAccount.empty().copyWith(amomimusId: widget.targetUserId, gender: gender);
        } else {
          // Fallback to current user if not found
          user = accountManager.currentUser;
          isOtherUser = false;
        }
      }
    }

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.watch<LanguageManager>().getString('profile'))),
        body: Center(child: Text(context.watch<LanguageManager>().getString('no_active_user'))),
      );
    }

    // Initialize bio controller with user's current bio (once)
    if (!_bioInitialized && !isOtherUser) {
      _bioController.text = user.bio == context.read<LanguageManager>().getString('no_bio_yet') || user.bio == "No bio yet" ? "" : user.bio;
      _bioInitialized = true;
    }

    return Scaffold(
      backgroundColor: isDark ? AmomimusDarkTheme.backgroundDark : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          context.watch<LanguageManager>().getString('profile'),
          style: TextStyle(
            fontFamily: 'SansSerif',
            fontWeight: FontWeight.bold,
            color: isDark
                ? AmomimusDarkTheme.policeLineYellow
                : AmomimusDarkTheme.primaryPurple,
          ),
        ),
        backgroundColor: isDark
            ? AmomimusDarkTheme.backgroundDark
            : Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (isOtherUser)
            IconButton(
              icon: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ReportDialog(
                    targetId: user.amomimusId,
                    isUserReport: true,
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildTopSection(context, user, isDark, isOtherUser, isLocked),
            const SizedBox(height: 30),
            if (isLocked) ...[
              _buildIndicatorCard(context, user, isDark),
              const SizedBox(height: 30),
              _buildLockedSection(context, isDark),
            ] else ...[
              _buildBioAndCoinsSection(context, user, isDark, isOtherUser),
              const SizedBox(height: 30),
              if (!isOtherUser) ...[
                _buildVaultAndMeritSection(context, user, isDark),
                const SizedBox(height: 30),
              ],
              _buildIndicatorCard(context, user, isDark),
              const SizedBox(height: 30),
              _buildRecentResonates(context, user, isDark, isOtherUser),
            ],
            const SizedBox(height: 100), // padding for FAB
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 24.0,
        ), // Adjust position to match feeds bottom:40
        child: AnimatedBuilder(
          animation: _fabAnimation,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, -_fabAnimation.value),
            child: child,
          ),
          child: SizedBox(
            width: 63,
            height: 63,
            child: FloatingActionButton(
              onPressed: () => Navigator.pop(context),
              backgroundColor: isDark
                  ? AmomimusDarkTheme.policeLineYellow
                  : AmomimusDarkTheme.primaryPurple,
              shape: const CircleBorder(),
              elevation: 6,
              child: Icon(
                GenderHelpers.getGenderIcon(user.gender),
                color: isDark ? Colors.black : Colors.white,
                size: 39,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
