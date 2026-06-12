import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../amomimusdark.dart';
import '../helpers/gender_helpers.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../services/account_manager.dart';
import '../services/chat_request_manager.dart';
import '../services/chatmodel.dart';
import '../widgets/report_dialog.dart';
import 'profile_screen.dart';
import '../language/language_manager.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AmomimusDarkTheme()),
        ChangeNotifierProvider(create: (context) => ChatModel()),
      ],
      child: const MaterialApp(
        home: AmomimusApp6(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

class AmomimusApp6 extends StatefulWidget {
  final String? username;
  final String? name;
  const AmomimusApp6({super.key, this.username, this.name});

  @override
  State<AmomimusApp6> createState() => _AmomimusApp6State();
}

class _AmomimusApp6State extends State<AmomimusApp6>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  ChatMessage? _replyingToMessage;

  double _headerProgress = 0.0;
  bool _isIslandExpanded = false;
  bool _isProfileMenuExpanded = false;

  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      try {
        double pixels = _scrollController.position.pixels;
        double linearProgress = (pixels / 80).clamp(0.0, 1.0).toDouble();

        setState(() {
          _headerProgress = Curves.easeInOut.transform(linearProgress);
          if (pixels > 15 && _isIslandExpanded) {
            _isIslandExpanded = false;
          }
        });
      } catch (_) {
        setState(() {
          _headerProgress = 0.0;
        });
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final text = _messageController.text.trim();
      final username = widget.username ?? '@partner_dev';
      final activeUser = context.read<AccountManager>().currentUser;
      final senderName = activeUser?.anonymousUsername ?? 'You';

      context.read<ChatModel>().sendMessage(
        username,
        text,
        senderName: senderName,
        targetName: widget.name,
        replyMessageId: _replyingToMessage?.id,
      );

      setState(() {
        _replyingToMessage = null;
      });
      _messageController.clear();
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _showMemoriesPopup(
    BuildContext context,
    String targetUsername,
    Color themeColor,
  ) {
    final themeProvider = context.read<AmomimusDarkTheme>();
    final isDark = themeProvider.isDarkMode;
    final currentBg = isDark ? AmomimusDarkTheme.backgroundDark : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark
        ? AmomimusDarkTheme.textSecondary
        : Colors.black54;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: currentBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: themeColor.withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.cloud, color: themeColor),
                        const SizedBox(width: 8),
                        Text(
                          context.read<LanguageManager>().getString('memories'),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: textSecondary),
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Consumer<ChatModel>(
                  builder: (ctx, chatModel, child) {
                    final pinnedMessages = chatModel.getPinnedMessages(
                      targetUsername,
                    );

                    if (pinnedMessages.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            context.read<LanguageManager>().getString('no_memories_pinned'),
                            style: TextStyle(
                              color: textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      );
                    }

                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: pinnedMessages.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (ctx, index) {
                          final msg = pinnedMessages[index];

                          String detailedTime = msg.timeStamp;
                          if (msg.createdAt != null) {
                            try {
                              final dt = DateTime.parse(msg.createdAt!);
                              final hourVal = dt.hour % 12 == 0
                                  ? 12
                                  : dt.hour % 12;
                              final period = dt.hour >= 12 ? 'PM' : 'AM';
                              detailedTime =
                                  "$hourVal:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')} $period";
                            } catch (_) {}
                          }

                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.black.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: themeColor.withOpacity(0.3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.02)
                                      : Colors.black.withOpacity(0.03),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      msg.senderName ?? 'User',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: themeColor,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          detailedTime,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: textSecondary,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                chatModel.unpinMessage(
                                                  targetUsername,
                                                  msg.id!,
                                                );
                                              },
                                              child: Icon(
                                                Icons.cloud,
                                                size: 14,
                                                color: themeColor.withOpacity(
                                                  0.7,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  msg.text,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14,
                                    height: 1.4,
                                    fontFamily: 'serif',
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AmomimusDarkTheme>();
    final chatModel = context.watch<ChatModel>();
    final activeChat = chatModel.getChatByUsername(
      widget.username ?? '@partner_dev',
      targetName: widget.name ?? 'Unknown',
    );
    final messages = activeChat.messages;

    final currentBg = themeProvider.isDarkMode
        ? AmomimusDarkTheme.backgroundDark
        : Colors.white;
    final currentSurface = themeProvider.isDarkMode
        ? AmomimusDarkTheme.surfaceDark
        : Colors.grey[200]!;
    final currentText = themeProvider.isDarkMode
        ? AmomimusDarkTheme.textPrimary
        : Colors.black87;
    final currentTextSecondary = themeProvider.isDarkMode
        ? AmomimusDarkTheme.textSecondary
        : Colors.black54;
    final dynamicAccentColor = themeProvider.isDarkMode
        ? AmomimusDarkTheme.policeLineYellow
        : AmomimusDarkTheme.primaryPurple;

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Get the target user's gender for dynamic styling
    final accountManager = context.watch<AccountManager>();
    final targetAccount = accountManager.accounts.firstWhere(
      (acc) => acc.amomimusId == widget.username,
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
    final dynamicHeaderIcon = GenderHelpers.getGenderIcon(targetGender);
    final dynamicHeaderColor = GenderHelpers.getGenderColor(targetGender);

    Widget expandableMiniIsland() {
      final Color dynamicOutlineColor = themeProvider.isDarkMode
          ? Colors.white.withOpacity(0.2)
          : Colors.black87.withOpacity(0.15);

      final Color islandBg = themeProvider.isDarkMode
          ? Colors.black54
          : const Color.fromARGB(221, 255, 255, 255);

      return GestureDetector(
        onTap: () {
          setState(() {
            _isIslandExpanded = !_isIslandExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          height: 46,
          width: _isIslandExpanded ? 225 : 46,
          decoration: BoxDecoration(
            color: islandBg,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: dynamicOutlineColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  themeProvider.isDarkMode ? 0.2 : 0.05,
                ),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _isIslandExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              layoutBuilder:
                  (topChild, topChildKey, bottomChild, bottomChildKey) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(key: bottomChildKey, child: bottomChild),
                        Positioned(key: topChildKey, child: topChild),
                      ],
                    );
                  },
              firstChild: SizedBox(
                height: 44,
                width: 44,
                child: Center(
                  child: Icon(
                    dynamicHeaderIcon,
                    color: dynamicHeaderColor,
                    size: 22,
                  ),
                ),
              ),
              secondChild: Container(
                width: 225,
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Icon(
                              dynamicHeaderIcon,
                              color: dynamicHeaderColor,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (targetAccount.anonymousUsername.isNotEmpty)
                                ? targetAccount.anonymousUsername
                                : activeChat.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                          Text(
                            activeChat.username,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: dynamicHeaderColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 14,
                        width: 1,
                        color: dynamicOutlineColor,
                      ),
                      const SizedBox(width: 2),
                      IconButton(
                        icon: Icon(
                          themeProvider.isDarkMode
                              ? Icons.wb_sunny_rounded
                              : Icons.nightlight_round,
                          size: 15,
                        ),
                        color: themeProvider.isDarkMode
                            ? AmomimusDarkTheme.policeLineYellow
                            : AmomimusDarkTheme.primaryPurple,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                        onPressed: () =>
                            context.read<AmomimusDarkTheme>().toggleTheme(),
                      ),
                      const SizedBox(width: 2),
                      IconButton(
                        icon: const Icon(
                          Icons.report_problem_outlined,
                          size: 15,
                        ),
                        color: Colors.orangeAccent,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ReportDialog(
                              targetId: widget.username ?? '',
                              isUserReport: true,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 2),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 15),
                        color: Colors.redAccent,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              final isDark = Provider.of<AmomimusDarkTheme>(context, listen: false).isDarkMode;
                              return AlertDialog(
                                backgroundColor: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
                                title: Text(context.read<LanguageManager>().getString('delete_chat_title'), style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                                content: Text(context.read<LanguageManager>().getString('delete_chat_room_confirm'), style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(dialogContext),
                                    child: Text(context.read<LanguageManager>().getString('cancel'), style: const TextStyle(color: Colors.grey)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext); // close dialog
                                      context.read<ChatModel>().deleteChat(widget.username ?? '');
                                      context.read<ChatRequestManager>().deleteRequestWith(widget.username ?? '');
                                      Navigator.pop(context); // exit room
                                    },
                                    child: Text(context.read<LanguageManager>().getString('delete'), style: const TextStyle(color: Colors.redAccent)),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget largeProfileWidget() {
      final Color uidColor = themeProvider.isDarkMode
          ? currentTextSecondary.withOpacity(0.7)
          : Colors.black45;

      return Container(
        width: double.infinity,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              height: 72,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // View Profile Bubble (Left)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    left: _isProfileMenuExpanded ? 9 : 78,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _isProfileMenuExpanded ? 1.0 : 0.0,
                      child: AnimatedBuilder(
                        animation: _waveController,
                        builder: (context, child) {
                          final offsetY = _isProfileMenuExpanded
                              ? sin(_waveController.value * 2 * pi) * 4
                              : 0.0;
                          return Transform.translate(
                            offset: Offset(0, offsetY),
                            child: child,
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            if (!_isProfileMenuExpanded) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  targetUserId: widget.username,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: themeProvider.isDarkMode
                                  ? Colors.black54
                                  : Colors.white,

                              shape: BoxShape.circle,
                              border: Border.all(
                                color: dynamicHeaderColor,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    themeProvider.isDarkMode ? 0.1 : 0.1,
                                  ),
                                  blurRadius: 0.3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color: currentText,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Memories Bubble (Right)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    right: _isProfileMenuExpanded ? 9 : 78,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _isProfileMenuExpanded ? 1.0 : 0.0,
                      child: AnimatedBuilder(
                        animation: _waveController,
                        builder: (context, child) {
                          final offsetY = _isProfileMenuExpanded
                              ? cos(_waveController.value * 2 * pi) * 4
                              : 0.0;
                          return Transform.translate(
                            offset: Offset(0, offsetY),
                            child: child,
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            if (!_isProfileMenuExpanded) return;
                            _showMemoriesPopup(
                              context,
                              widget.username ?? '@partner_dev',
                              dynamicHeaderColor,
                            );
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: themeProvider.isDarkMode
                                  ? Colors.black54
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: dynamicHeaderColor,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    themeProvider.isDarkMode ? 0.3 : 0.1,
                                  ),
                                  blurRadius: 3,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.cloud_outlined,
                              color: currentText,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Main Avatar
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isProfileMenuExpanded = !_isProfileMenuExpanded;
                      });
                    },
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color:
                            currentBg, // add bg so shadow doesn't show through
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: dynamicHeaderColor,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        dynamicHeaderIcon,
                        color: dynamicHeaderColor,
                        size: 38,
                      ),
                    ),
                  ),
                  if (activeChat.isOnline)
                    Positioned(
                      bottom: -2,
                      right: 62,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: themeProvider.isDarkMode
                                ? AmomimusDarkTheme.surfaceDark
                                : Colors.white,
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              (targetAccount.anonymousUsername.isNotEmpty)
                  ? targetAccount.anonymousUsername
                  : activeChat.name,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              activeChat.username,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: uidColor,
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      );
    }

    return Theme(
      data: AmomimusDarkTheme.themeData,
      child: Builder(
        builder: (context) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: themeProvider.isDarkMode
                  ? Brightness.light
                  : Brightness.dark,
              statusBarBrightness: themeProvider.isDarkMode
                  ? Brightness.dark
                  : Brightness.light,
              systemNavigationBarColor: currentSurface,
              systemNavigationBarIconBrightness: themeProvider.isDarkMode
                  ? Brightness.light
                  : Brightness.dark,
            ),
            child: Scaffold(
              backgroundColor: currentBg,
              body: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AnimatedBuilder(
                      animation: _waveController,
                      builder: (context, child) {
                        return SizedBox(
                          height: 140,
                          child: Stack(
                            children: [
                              Opacity(
                                opacity: 0.1,
                                child: ClipPath(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  clipper: AmomimusWaveClipper(
                                    _waveController.value,
                                    0.0,
                                  ),
                                  child: Container(
                                    color: themeProvider.isDarkMode
                                        ? const Color.fromARGB(255, 255, 187, 0)
                                        : AmomimusDarkTheme.primaryPurple,
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: 0.25,
                                child: ClipPath(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  clipper: AmomimusWaveClipper(
                                    _waveController.value,
                                    0.6,
                                  ),
                                  child: Container(
                                    color: themeProvider.isDarkMode
                                        ? AmomimusDarkTheme.policeLineYellow
                                        : AmomimusDarkTheme.primaryPurple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned.fill(
                    child: Column(
                      children: [
                        Expanded(
                          child: CustomScrollView(
                            controller: _scrollController,
                            slivers: [
                              SliverPadding(
                                padding: EdgeInsets.only(
                                  left: 14,
                                  right: 14,
                                  bottom: 14,
                                  top: statusBarHeight + 20,
                                ),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate((
                                    context,
                                    index,
                                  ) {
                                    if (index == 0) {
                                      return Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 30,
                                          top: 15,
                                        ),
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        child: largeProfileWidget(),
                                      );
                                    }
                                    final msg = messages[index - 1];
                                    final repliedMsg =
                                        msg.replyMessageId != null
                                        ? messages.firstWhere(
                                            (m) => m.id == msg.replyMessageId,
                                            orElse: () => ChatMessage(
                                              text: 'Message deleted',
                                              senderId: '',
                                              timeStamp: '',
                                            ),
                                          )
                                        : null;

                                    return MessageBubble(
                                      message: msg,
                                      repliedMessage: repliedMsg,
                                      isPinned: context
                                          .watch<ChatModel>()
                                          .isPinned(
                                            widget.username ?? '@partner_dev',
                                            msg.id ?? '',
                                          ),
                                      onTogglePin: () {
                                        final cm = context.read<ChatModel>();
                                        final target =
                                            widget.username ?? '@partner_dev';
                                        final msgId = msg.id ?? '';
                                        if (cm.isPinned(target, msgId)) {
                                          cm.unpinMessage(target, msgId);
                                        } else {
                                          final success = cm.pinMessage(
                                            target,
                                            msgId,
                                          );
                                          if (!success) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  context.read<LanguageManager>().getString('pin_limit_error'),
                                                ),
                                                backgroundColor:
                                                    Colors.redAccent,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      onReply: () {
                                        setState(() {
                                          _replyingToMessage = msg;
                                        });
                                      },
                                    );
                                  }, childCount: messages.length + 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_replyingToMessage != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: currentSurface,
                              border: Border(
                                top: BorderSide(
                                  color: currentSurface.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: dynamicAccentColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  margin: const EdgeInsets.only(right: 8),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${context.read<LanguageManager>().getString('replying_to')}${_replyingToMessage!.senderName ?? 'User'}",
                                        style: TextStyle(
                                          color: dynamicAccentColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _replyingToMessage!.text,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: currentTextSecondary,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: currentTextSecondary,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _replyingToMessage = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        // BAGIAN INI SUDAH DIBATASI MAKSIMAL 1/3 TINGGI HP
                        Container(
                          constraints: BoxConstraints(
                            maxHeight:
                                screenHeight * 0.33, // Maksimal 1/3 layar hp
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: currentSurface.withOpacity(0.15),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .end, // Tombol send tetap rapi di bawah saat teks memanjang
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Icon(
                                  Icons.sentiment_satisfied_alt_outlined,
                                  color: dynamicAccentColor,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SingleChildScrollView(
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.onDrag,
                                  child: TextField(
                                    controller: _messageController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines:
                                        null, // Membiarkannya bertambah baris secara dinamis
                                    minLines: 1,
                                    style: TextStyle(
                                      color: currentText,
                                      fontSize: 15,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                      border: InputBorder.none,
                                      hintText: context.watch<LanguageManager>().getString('write_message'),
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: currentTextSecondary.withOpacity(
                                          0.7,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 7),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: _sendMessage,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AmomimusDarkTheme.primaryPurple,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.send,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.lerp(
                        Alignment.topRight,
                        Alignment.topCenter,
                        _headerProgress,
                      )!,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: statusBarHeight + 10,
                          right: 14 * (1 - _headerProgress),
                        ), // Add right margin when at top right
                        child: expandableMiniIsland(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final ChatMessage? repliedMessage;
  final VoidCallback? onReply;
  final bool isPinned;
  final VoidCallback? onTogglePin;

  const MessageBubble({
    super.key,
    required this.message,
    this.repliedMessage,
    this.onReply,
    this.isPinned = false,
    this.onTogglePin,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AmomimusDarkTheme>();
    final activeUser = context.watch<AccountManager>().currentUser;
    final isDark = themeProvider.isDarkMode;
    final isUserMessage = widget.message.senderId == activeUser?.amomimusId;
    Color bubbleColor = isDark ? AmomimusDarkTheme.surfaceDark : Colors.white;
    final Color customBorderColor = isUserMessage
        ? AmomimusDarkTheme.policeLineYellow
        : AmomimusDarkTheme.primaryPurple;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color textSecondaryColor = isDark
        ? AmomimusDarkTheme.textSecondary
        : Colors.black54;

    // Check if text is long enough to need collapsing
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.message.text,
        style: TextStyle(
          color: textColor,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          fontFamily: 'serif',
        ),
      ),
      maxLines: 4,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width * 0.62 - 32);
    final bool isOverflowing = textPainter.didExceedMaxLines;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 11.0),
      child: Row(
        mainAxisAlignment: isUserMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isUserMessage) ...[
            Text(
              widget.message.timeStamp,
              style: TextStyle(
                fontSize: 9,
                color: textSecondaryColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(width: 8),
          ],
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: isDark
                    ? AmomimusDarkTheme.backgroundDark
                    : Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (sheetContext) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.reply, color: customBorderColor),
                          title: Text(
                            context.read<LanguageManager>().getString('reply'),
                            style: TextStyle(color: textColor),
                          ),
                          onTap: () {
                            Navigator.pop(sheetContext);
                            if (widget.onReply != null) widget.onReply!();
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            widget.isPinned
                                ? Icons.cloud
                                : Icons.cloud_outlined,
                            color: customBorderColor,
                          ),
                          title: Text(
                            widget.isPinned
                                ? context.read<LanguageManager>().getString('unpin_memories')
                                : context.read<LanguageManager>().getString('pin_memories'),
                            style: TextStyle(color: textColor),
                          ),
                          onTap: () {
                            Navigator.pop(sheetContext);
                            if (widget.onTogglePin != null) {
                              widget.onTogglePin!();
                            }
                          },
                        ),
                        if (!isUserMessage)
                          ListTile(
                            leading: const Icon(
                              Icons.report_gmailerrorred,
                              color: Colors.redAccent,
                            ),
                            title: Text(
                              context.read<LanguageManager>().getString('report'),
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                            onTap: () {
                              Navigator.pop(sheetContext);
                              showDialog(
                                context: context,
                                builder: (context) => ReportDialog(
                                  targetId: widget.message.id ?? '',
                                  isUserReport: false,
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  );
                },
              );
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.62,
              ),
              child: Column(
                crossAxisAlignment: isUserMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (widget.message.senderName != null)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 3,
                        right: isUserMessage ? 4 : 0,
                        left: isUserMessage ? 0 : 4,
                      ),
                      child: Text(
                        widget.message.senderName!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isUserMessage
                              ? AmomimusDarkTheme.policeLineYellow
                              : AmomimusDarkTheme.primaryPurple,
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: isUserMessage
                            ? const Radius.circular(20)
                            : const Radius.circular(4),
                        bottomRight: isUserMessage
                            ? const Radius.circular(4)
                            : const Radius.circular(20),
                      ),
                      border: Border.all(
                        color: customBorderColor.withOpacity(0.7),
                        width: 1.85,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.repliedMessage != null)
                          GestureDetector(
                            onTap: () {
                              if (widget.repliedMessage!.text.length > 100) {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    backgroundColor: bubbleColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: customBorderColor.withOpacity(
                                          0.7,
                                        ),
                                        width: 1.85,
                                      ),
                                    ),
                                    content: Text(
                                      widget.repliedMessage!.text,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.black.withOpacity(0.2)
                                    : const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: customBorderColor.withOpacity(0.9),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark
                                        ? Colors.white.withOpacity(0.02)
                                        : Colors.black.withOpacity(0.005),
                                    offset: const Offset(0, 2),
                                    blurRadius: 1,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.repliedMessage!.senderName ?? 'User',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: customBorderColor,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.repliedMessage!.text,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: textSecondaryColor,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        RichText(
                          maxLines: _isExpanded ? null : 4,
                          overflow: _isExpanded
                              ? TextOverflow.clip
                              : TextOverflow.ellipsis,
                          text: TextSpan(
                            text: widget.message.text,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              fontFamily: 'serif',
                            ),
                            children: [
                              if (widget.isPinned)
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
                                    child: Icon(
                                      Icons.cloud,
                                      size: 12,
                                      color: customBorderColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (isOverflowing)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    size: 16,
                                    color: customBorderColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _isExpanded ? context.read<LanguageManager>().getString('show_less') : context.read<LanguageManager>().getString('show_more'),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: customBorderColor,
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
            ),
          ),
          if (!isUserMessage) ...[
            const SizedBox(width: 8),
            Text(
              widget.message.timeStamp,
              style: TextStyle(
                fontSize: 9,
                color: textSecondaryColor.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AmomimusWaveClipper extends CustomClipper<Path> {
  final double animationValue;
  final double offset;
  AmomimusWaveClipper(this.animationValue, this.offset);

  @override
  Path getClip(Size size) {
    Path path = Path();
    double angle = (animationValue * 2 * pi) + (offset * pi);
    double waveSin = sin(angle);
    double waveCos = cos(angle);
    double startY = 55 + (waveSin * 22);
    double endY = 45 + (waveCos * 18);

    path.moveTo(0, size.height);
    path.lineTo(0, startY);
    double controlX = (size.width * 0.35) + (waveCos * 30);
    double controlY = 85 + (waveSin * 25);
    path.quadraticBezierTo(controlX, controlY, size.width, endY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant AmomimusWaveClipper oldClipper) => true;
}
