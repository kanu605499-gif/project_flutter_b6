import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../services/account_manager.dart';
import '../amomimusdark.dart';
import '../services/chat_request_manager.dart';
import '../services/chatmodel.dart';
import '../database_helper.dart';
import 'roomchat.dart';
import '../models/user_model.dart';
import '../models/user_model.dart';
import '../helpers/gender_helpers.dart';
import '../language/language_manager.dart';

class AmomimusApp7 extends StatefulWidget {
  const AmomimusApp7({super.key});

  @override
  State<AmomimusApp7> createState() => _AmomimusApp7State();
}

class _AmomimusApp7State extends State<AmomimusApp7>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _headerOpacity = 0.0;
  bool _isIslandExpanded = false;

  late AnimationController _particleController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      try {
        double pixels = _scrollController.position.pixels;
        double linearOpacity = ((pixels - 40) / 60).clamp(0.0, 1.0).toDouble();

        setState(() {
          _headerOpacity = Curves.easeInOut.transform(linearOpacity);
          if (pixels > 15 && _isIslandExpanded) {
            _isIslandExpanded = false;
          }
        });
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _showRequestsBottomSheet(
    BuildContext context,
    ChatRequestManager reqManager,
    AmomimusDarkTheme themeProvider,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = themeProvider.isDarkMode;
        final bgCol = isDark ? AmomimusDarkTheme.surfaceDark : Colors.white;
        final textCol = isDark ? Colors.white : Colors.black87;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bgCol,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.read<LanguageManager>().getString('incoming_requests'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textCol,
                ),
              ),
              const SizedBox(height: 16),
              if (reqManager.incomingRequests.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    context.read<LanguageManager>().getString('no_incoming_requests'),
                    style: TextStyle(color: textCol.withOpacity(0.6)),
                  ),
                ),
              ...reqManager.incomingRequests.map((req) {
                final accountManager = context.read<AccountManager>();
                final senderAccount = accountManager.accounts.firstWhere(
                  (acc) => acc.amomimusId == req.senderId,
                  orElse: () => UserAccount(
                    email: '',
                    realUsername: '',
                    anonymousUsername: '',
                    amomimusId: '',
                    gender: 'Amo',
                    registrationDate: '',
                    isDemo: false,
                  ),
                );
                final senderGender = senderAccount.gender;
                final senderIcon = GenderHelpers.getGenderIcon(senderGender);
                final senderColor = GenderHelpers.getGenderColor(senderGender);

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: senderColor, width: 1.5),
                    ),
                    child: Icon(senderIcon, color: senderColor, size: 22),
                  ),
                  title: Text(
                    senderAccount.anonymousUsername.isNotEmpty
                        ? senderAccount.anonymousUsername
                        : req.senderName,
                    style: TextStyle(
                      color: textCol,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'ID: ${req.senderId}',
                    style: TextStyle(
                      color: textCol.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.redAccent),
                        onPressed: () {
                          reqManager.rejectRequest(req.id);
                          Navigator.pop(ctx);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          reqManager.acceptRequest(req.id);
                          // Initialize chat with accepted message
                          context.read<ChatModel>().sendMessage(
                            req.senderId,
                            context.read<LanguageManager>().getString('chat_req_accepted'),
                            targetName: req.senderName,
                          );
                          Navigator.pop(ctx);
                        },
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AmomimusDarkTheme>();
    final chatModel = context.watch<ChatModel>();
    final chatList = chatModel.chatList;
    final currentBg = themeProvider.isDarkMode
        ? AmomimusDarkTheme.backgroundDark
        : Colors.white;
    final currentSurface = themeProvider.isDarkMode
        ? AmomimusDarkTheme.surfaceDark
        : Colors.grey[200]!;
    final dynamicAccentColor = themeProvider.isDarkMode
        ? AmomimusDarkTheme.policeLineYellow
        : AmomimusDarkTheme.primaryPurple;

    final double statusBarHeight = MediaQuery.of(context).padding.top;

    // Island mini di atas saat di-scroll
    Widget expandableMiniIsland() {
      final Color dynamicOutlineColor = themeProvider.isDarkMode
          ? Colors.white.withOpacity(0.2)
          : Colors.black87.withOpacity(0.15);
      return GestureDetector(
        onTap: () => setState(() => _isIslandExpanded = !_isIslandExpanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          height: 46,
          width: _isIslandExpanded ? 180 : 46,
          decoration: BoxDecoration(
            color: themeProvider.isDarkMode
                ? currentSurface.withOpacity(0.9)
                : Colors.grey[100]!.withOpacity(0.95),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: dynamicOutlineColor, width: 1.2),
          ),
          child: _isIslandExpanded
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      context.watch<LanguageManager>().getString('messages'),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        themeProvider.isDarkMode
                            ? Icons.wb_sunny_rounded
                            : Icons.nightlight_round,
                        size: 16,
                      ),
                      color: dynamicAccentColor,
                      onPressed: () =>
                          context.read<AmomimusDarkTheme>().toggleTheme(),
                    ),
                  ],
                )
              : Center(
                  child: Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: dynamicAccentColor,
                    size: 20,
                  ),
                ),
        ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: themeProvider.isDarkMode
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: currentSurface,
      ),
      child: Scaffold(
        backgroundColor: currentBg,
        body: Stack(
          children: [
            // --- Background Partikel Melayang ---
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ParticleBackgroundPainter(
                      progress: _particleController.value,
                      color: dynamicAccentColor.withOpacity(0.12),
                    ),
                  );
                },
              ),
            ),

            // --- Konten Utama ---
            Positioned.fill(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: statusBarHeight + 40,
                        bottom: 20,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context.watch<LanguageManager>().getString('amomus_list'),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: Icon(
                                  Icons.switch_account_outlined,
                                  color: dynamicAccentColor,
                                ),
                                onPressed: () {
                                  final accountManager = context
                                      .read<AccountManager>();
                                  final accounts = accountManager.accounts
                                      .where((a) => a.isDemo)
                                      .toList();
                                  final isDark = themeProvider.isDarkMode;

                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (ctx) {
                                      final sheetBg = isDark
                                          ? AmomimusDarkTheme.surfaceDark
                                          : Colors.white;
                                      final textCol = isDark
                                          ? Colors.white
                                          : Colors.black87;
                                      final subCol = isDark
                                          ? AmomimusDarkTheme.textSecondary
                                          : Colors.black54;

                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: sheetBg,
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(24),
                                              ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                color: isDark
                                                    ? Colors.white24
                                                    : Colors.black12,
                                                borderRadius:
                                                    BorderRadius.circular(2.5),
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              context.read<LanguageManager>().getString('switch_account'),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: textCol,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            if (accounts.isEmpty)
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  20,
                                                ),
                                                child: Text(
                                                  context.read<LanguageManager>().getString('no_accounts_registered'),
                                                  style: TextStyle(
                                                    color: subCol,
                                                  ),
                                                ),
                                              )
                                            else
                                              ...accounts.map((acc) {
                                                final isActive =
                                                    acc.id ==
                                                    accountManager
                                                        .currentUser
                                                        ?.id;
                                                final genderColor =
                                                    GenderHelpers.getGenderColor(
                                                      acc.gender,
                                                    );
                                                final genderIcon =
                                                    GenderHelpers.getGenderIcon(
                                                      acc.gender,
                                                    );

                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                      ),
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    onTap: () {
                                                      accountManager
                                                          .switchAccount(acc);
                                                      // Sync ChatModel with the new account
                                                      context
                                                          .read<ChatModel>()
                                                          .setCurrentUser(
                                                            acc.amomimusId,
                                                            acc.anonymousUsername,
                                                          );
                                                      Navigator.pop(ctx);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 14,
                                                            vertical: 12,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: isActive
                                                            ? genderColor
                                                                  .withOpacity(
                                                                    0.12,
                                                                  )
                                                            : Colors
                                                                  .transparent,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                        border: Border.all(
                                                          color: isActive
                                                              ? genderColor
                                                                    .withOpacity(
                                                                      0.6,
                                                                    )
                                                              : (isDark
                                                                    ? Colors
                                                                          .white12
                                                                    : Colors
                                                                          .black12),
                                                          width: isActive
                                                              ? 1.5
                                                              : 1,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 40,
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12,
                                                                  ),
                                                              border: Border.all(
                                                                color:
                                                                    genderColor,
                                                                width: 1.2,
                                                              ),
                                                            ),
                                                            child: Icon(
                                                              genderIcon,
                                                              color:
                                                                  genderColor,
                                                              size: 22,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  acc.anonymousUsername,
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        textCol,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${acc.amomimusId} · ${acc.gender}',
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color:
                                                                        genderColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          if (isActive)
                                                            Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color:
                                                                  genderColor,
                                                              size: 20,
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            const SizedBox(height: 8),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // List Orang Menggunakan Kustom ListTile dengan Border Melengkung
                  Consumer<ChatRequestManager>(
                    builder: (context, reqManager, child) {
                      final requests = reqManager.incomingRequests;
                      if (requests.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        );
                      }

                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          child: InkWell(
                            onTap: () => _showRequestsBottomSheet(
                              context,
                              reqManager,
                              themeProvider,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              height: 65,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: themeProvider.isDarkMode
                                    ? AmomimusDarkTheme.surfaceDark
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: dynamicAccentColor.withOpacity(0.5),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  AnimatedBuilder(
                                    animation: _pulseController,
                                    builder: (context, child) {
                                      // Vibrate animation: rapid slight rotation
                                      final double angle =
                                          sin(
                                            _pulseController.value *
                                                3.14159 *
                                                20,
                                          ) *
                                          0.15;
                                      return Transform.rotate(
                                        angle: angle,
                                        child: child,
                                      );
                                    },
                                    child: Icon(
                                      Icons.mark_email_unread_rounded,
                                      color: dynamicAccentColor,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      '${context.watch<LanguageManager>().getString('chat_requests')} (${requests.length})',
                                      style: TextStyle(
                                        color: themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: dynamicAccentColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.chevron_right,
                                      color: themeProvider.isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final chat = chatList[index];
                        return ChatListTileWidget(chat: chat);
                      }, childCount: chatList.length),
                    ),
                  ),
                ],
              ),
            ),

            // Mini Floating Island di Atas pas di-scroll kebawah
            if (_headerOpacity > 0.0)
              Positioned(
                top: statusBarHeight + 10,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Opacity(
                    opacity: _headerOpacity,
                    child: expandableMiniIsland(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Widget Komponen Item Chat / List Tile Orang
class ChatListTileWidget extends StatelessWidget {
  final ChatPreview chat;
  const ChatListTileWidget({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AmomimusDarkTheme>();
    final isDark = themeProvider.isDarkMode;

    final Color tileBg = isDark ? AmomimusDarkTheme.surfaceDark : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subTextColor = isDark
        ? AmomimusDarkTheme.textSecondary
        : Colors.black54;

    // Get the target user's gender for dynamic styling
    final accountManager = context.watch<AccountManager>();
    final targetAccount = accountManager.accounts.firstWhere(
      (acc) => acc.amomimusId == chat.username,
      orElse: () => UserAccount(
        email: '',
        realUsername: '',
        anonymousUsername: '',
        amomimusId: '',
        gender: 'Amo',
        registrationDate: '',
        isDemo: false,
      ),
    );
    final targetGender = targetAccount.gender;
    final dynamicTileIcon = GenderHelpers.getGenderIcon(targetGender);
    final dynamicTileColor = GenderHelpers.getGenderColor(targetGender);

    final Color customBorderColor = (chat.unreadCount > 0)
        ? dynamicTileColor
        : dynamicTileColor.withOpacity(0.5);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Dismissible(
        key: Key(chat.username),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 28,
          ),
        ),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                backgroundColor: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
                title: Text(context.read<LanguageManager>().getString('delete_chat_title'), style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                content: Text("${context.read<LanguageManager>().getString('delete_chat_confirm_prefix')}${chat.name}${context.read<LanguageManager>().getString('delete_chat_confirm_suffix')}", style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: Text(context.read<LanguageManager>().getString('cancel'), style: const TextStyle(color: Colors.grey)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    child: Text(context.read<LanguageManager>().getString('delete'), style: const TextStyle(color: Colors.redAccent)),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) {
          context.read<ChatModel>().deleteChat(chat.username);
          context.read<ChatRequestManager>().deleteRequestWith(chat.username);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${context.read<LanguageManager>().getString('chat_deleted_prefix')}${chat.name}${context.read<LanguageManager>().getString('chat_deleted_suffix')}'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: InkWell(
          onTap: () {
            context.read<ChatModel>().markAsRead(chat.username);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AmomimusApp6(username: chat.username, name: chat.name),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: tileBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: customBorderColor.withOpacity(0.7),
                width: 1.8,
              ),
            ),
            child: Row(
              children: [
                // Avatar Kotak Melengkung + Indikator Online mirip `image_d3b1e5.png`
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: dynamicTileColor, width: 1.2),
                      ),
                      child: Icon(
                        dynamicTileIcon,
                        color: dynamicTileColor,
                        size: 28,
                      ),
                    ),
                    if (chat.isOnline)
                      Positioned(
                        bottom: -1,
                        right: -1,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: tileBg, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),

                // Detail Nama dan Pesan Terakhir
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (targetAccount.anonymousUsername.isNotEmpty)
                                ? targetAccount.anonymousUsername
                                : chat.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          Text(
                            chat.time,
                            style: TextStyle(
                              fontSize: 10,
                              color: subTextColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        chat.username,
                        style: TextStyle(
                          fontSize: 11,
                          color: AmomimusDarkTheme.policeLineYellow.withOpacity(
                            0.8,
                          ),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: subTextColor,
                          fontFamily: 'serif',
                        ),
                      ),
                    ],
                  ),
                ),

                // Badge Pesan Belum Dibaca (jika ada)
                if (chat.unreadCount > 0) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AmomimusDarkTheme.primaryPurple,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "${chat.unreadCount}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Sistem Engine Partikel Melayang (Dari Bawah) ---
class ParticleBackgroundPainter extends CustomPainter {
  final double progress;
  final Color color;
  late List<StaticParticle> particles;

  ParticleBackgroundPainter({required this.progress, required this.color}) {
    Random seedRand = Random(
      2026,
    ); // Mengunci seed supaya titik tidak lompat acak
    particles = List.generate(30, (index) {
      return StaticParticle(
        xPercent: seedRand.nextDouble(),
        yBasePercent: seedRand.nextDouble(),
        size: seedRand.nextDouble() * 3.5 + 1.5,
        speedFactor: seedRand.nextDouble() * 0.4 + 0.6,
        opacityFactor: seedRand.nextDouble() * 0.7 + 0.3,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      // Menggerakkan partikel ke atas secara mulus (mengurangi progress)
      double yFraction =
          (particle.yBasePercent - (progress * particle.speedFactor)) % 1.0;

      double x = particle.xPercent * size.width;
      double y = yFraction * size.height;

      paint.color = color.withOpacity(color.opacity * particle.opacityFactor);
      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticleBackgroundPainter oldDelegate) => true;
}

class StaticParticle {
  final double xPercent;
  final double yBasePercent;
  final double size;
  final double speedFactor;
  final double opacityFactor;

  StaticParticle({
    required this.xPercent,
    required this.yBasePercent,
    required this.size,
    required this.speedFactor,
    required this.opacityFactor,
  });
}
