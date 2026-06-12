import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_flutter_b6/services/chat_request_manager.dart';
import 'package:project_flutter_b6/screens/chatroomhome.dart';
import 'package:project_flutter_b6/screens/roomchat.dart';
import 'package:provider/provider.dart';

import '../amomimusdark.dart';
import '../services/chatmodel.dart';
import '../database/preference_handler.dart';
import 'login.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../models/comment_model.dart';
import '../services/account_manager.dart';
import '../services/feed_manager.dart';
import '../services/notification_manager.dart';
import '../models/notification_model.dart';
import '../database_helper.dart';
import 'forum_page.dart';
import 'profile_screen.dart';
import '../helpers/gender_helpers.dart';
import '../widgets/report_dialog.dart';
import '../data/anonymous_names.dart';
import '../language/language_manager.dart';

class AmomimusApp5 extends StatefulWidget {
  const AmomimusApp5({super.key});

  @override
  State<AmomimusApp5> createState() => _AmomimusApp5State();
}

class _AmomimusApp5State extends State<AmomimusApp5>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _waveController;
  final TextEditingController _postController = TextEditingController();
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _waveController.dispose();
    _postController.dispose();
    super.dispose();
  }

  void _summonPostSheet(BuildContext context, bool isDark) {
    final currentUser = Provider.of<AccountManager>(context, listen: false).currentUser;
    if (currentUser == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.watch<LanguageManager>().getString('create_post'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AmomimusDarkTheme.textPrimary
                          : const Color.fromARGB(255, 140, 113, 199),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _postController,
                    maxLines: 5,
                    maxLength: 300,
                    style: TextStyle(
                      color: isDark
                          ? AmomimusDarkTheme.textPrimary
                          : Colors.black,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: context.watch<LanguageManager>().getString('whats_on_your_mind'),
                      hintStyle: TextStyle(
                        color: isDark
                            ? AmomimusDarkTheme.textSecondary
                            : Colors.grey[500],
                        fontSize: 16,
                      ),
                      filled: false,
                      contentPadding: const EdgeInsets.all(16),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_postController.text.trim().isNotEmpty) {
                          AccountType accountType;
                          switch (currentUser.gender) {
                            case 'Ami': accountType = AccountType.ami; break;
                            case 'Amom': accountType = AccountType.amom; break;
                            case 'Amo': accountType = AccountType.amo; break;
                            default: accountType = AccountType.user; break;
                          }
                          
                          final newPost = FeedModel(
                            userName: currentUser.anonymousUsername,
                            id: "#AMM-${DateTime.now().millisecondsSinceEpoch % 100000}",
                            type: accountType,
                            content: _postController.text,
                            timeStamp: "Just now",
                            realAuthorId: currentUser.amomimusId,
                            realAuthorName: currentUser.anonymousUsername,
                          );
                          Provider.of<FeedManager>(context, listen: false).addPost(newPost);
                          
                          _postController.clear();
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AmomimusDarkTheme.primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        context.watch<LanguageManager>().getString('send_post'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showNotificationsSheet(BuildContext context, bool isDark) {
    final currentUser = Provider.of<AccountManager>(context, listen: false).currentUser;
    if (currentUser == null) return;
    
    final notifManager = Provider.of<NotificationManager>(context, listen: false);
    final notifications = notifManager.getNotificationsForUser(currentUser.amomimusId);

    // Mark as read when opened
    notifManager.markAllAsReadForUser(currentUser.amomimusId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.watch<LanguageManager>().getString('notifications'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AmomimusDarkTheme.textPrimary : Colors.black,
                ),
              ),
              const Divider(),
              Expanded(
                child: notifications.isEmpty
                    ? Center(
                        child: Text(
                          context.watch<LanguageManager>().getString('no_notifications'),
                          style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
                        ),
                      )
                    : ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notif = notifications[index];
                          IconData iconData;
                          Color iconColor = Colors.transparent;
                          String translatedMessage = "";
                          switch (notif.type) {
                            case NotificationType.resonate:
                              iconData = Icons.favorite;
                              iconColor = Colors.red;
                              translatedMessage = context.read<LanguageManager>().getString('notif_resonate');
                              break;
                            case NotificationType.comment:
                              iconData = Icons.chat_bubble;
                              iconColor = AmomimusDarkTheme.primaryPurple;
                              translatedMessage = context.read<LanguageManager>().getString('notif_comment');
                              break;
                            case NotificationType.reply:
                              iconData = Icons.reply;
                              iconColor = isDark ? Colors.yellow : Colors.amber.shade800;
                              translatedMessage = context.read<LanguageManager>().getString('notif_reply');
                              break;
                          }
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: iconColor.withValues(alpha: 0.2),
                              child: Icon(iconData, color: iconColor, size: 20),
                            ),
                            title: RichText(
                              text: TextSpan(
                                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                                children: [
                                  TextSpan(text: "${notif.actorName} ", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: translatedMessage),
                                ],
                              ),
                            ),
                            subtitle: Text(
                              context.read<LanguageManager>().getString('just_now'), // Ideally parse ISO string to time ago
                              style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 12),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              if (notif.feedId.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForumPage(feedId: notif.feedId),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final amomimusTheme = Provider.of<AmomimusDarkTheme>(context);
    final feedManager = Provider.of<FeedManager>(context);
    final currentUser = Provider.of<AccountManager>(context).currentUser;
    final isDark = amomimusTheme.isDarkMode;

    final blockedUsers = currentUser?.blockedUsers ?? [];
    final hiddenFeeds = currentUser?.hiddenFeeds ?? [];
    final feedData = feedManager.feeds.where((feed) {
      if (hiddenFeeds.contains(feed.id)) return false;
      if (feed.realAuthorId != null && blockedUsers.contains(feed.realAuthorId)) return false;
      if (blockedUsers.contains(feed.id)) return false;
      if (blockedUsers.contains(feed.userName)) return false;
      return true;
    }).toList();

    final currentScaffoldBg = isDark
        ? AmomimusDarkTheme.backgroundDark
        : Colors.white;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        
        DateTime now = DateTime.now();
        if (currentBackPressTime == null || 
            now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
          currentBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.read<LanguageManager>().getString('press_back_again')),
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          // Exit the app
          SystemNavigator.pop();
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: isDark
              ? AmomimusDarkTheme.surfaceDark
              : Colors.white,
          systemNavigationBarIconBrightness: isDark
              ? Brightness.light
              : Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: currentScaffoldBg,
          body: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 80,
                child: AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    return SizedBox(
                      height: 110,
                      child: Stack(
                        children: [
                          Opacity(
                            opacity: 0.3,
                            child: ClipPath(
                              clipper: AmomimusWaveClipper(
                                _waveController.value,
                                0.0,
                              ),
                              child: Container(
                                color: isDark
                                    ? const Color.fromARGB(255, 255, 187, 0)
                                    : AmomimusDarkTheme.primaryPurple,
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: 0.8,
                            child: ClipPath(
                              clipper: AmomimusWaveClipper(
                                _waveController.value,
                                0.6,
                              ),
                              child: Container(
                                color: isDark
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
                child: feedData.isEmpty
                    ? Center(child: Text(context.watch<LanguageManager>().getString('no_feeds')))
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 95, bottom: 120),
                        itemCount: feedData.length,
                        itemBuilder: (context, index) => FeedCard(
                          model: feedData[index],
                          feedIndex: index,
                        ),
                      ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 90,
                  padding: const EdgeInsets.only(top: 30, right: 16, left: 16),
                  color: currentScaffoldBg.withOpacity(0.9),
                  child: Row(
                    children: [
                      Builder(
                        builder: (scaffoldContext) {
                          return IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: isDark
                                  ? AmomimusDarkTheme.textPrimary
                                  : Colors.black,
                            ),
                            onPressed: () =>
                                Scaffold.of(scaffoldContext).openDrawer(),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          amomimusTheme.toggleTheme();
                        },
                        child: const Text(
                          "Amomimus",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AmomimusDarkTheme.primaryPurple,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Builder(
                        builder: (context) {
                          final currentUser = Provider.of<AccountManager>(context).currentUser;
                          final notifManager = Provider.of<NotificationManager>(context);
                          final unreadCount = currentUser != null 
                              ? notifManager.getUnreadCountForUser(currentUser.amomimusId) 
                              : 0;

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.notifications_none,
                                  color: isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple,
                                ),
                                onPressed: () => _showNotificationsSheet(context, isDark),
                              ),
                              if (unreadCount > 0)
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Builder(
                          builder: (context) {
                            final chatModel = context.watch<ChatModel>();
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(
                                  Icons.messenger_outline,
                                  color: isDark
                                      ? AmomimusDarkTheme.policeLineYellow
                                      : AmomimusDarkTheme.primaryPurple,
                                ),
                                if (chatModel.hasUnreadMessages)
                                  Positioned(
                                    top: -2,
                                    right: -2,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AmomimusApp7(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 60),
                      IconButton(
                        icon: Icon(
                          Icons.person_outline,
                          color: isDark
                              ? AmomimusDarkTheme.policeLineYellow
                              : AmomimusDarkTheme.primaryPurple,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.primaryDelta! < -7) {
                        _summonPostSheet(context, isDark);
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, -_animation.value),
                        child: child,
                      ),
                      child: SizedBox(
                        width: 63,
                        height: 63,
                        child: FloatingActionButton(
                          onPressed: () => _summonPostSheet(context, isDark),
                          backgroundColor: isDark
                              ? const Color(0xFF8C72C4)
                              : AmomimusDarkTheme.policeLineYellow,
                          shape: const CircleBorder(),
                          elevation: 6,
                          child: Icon(
                            Icons.keyboard_arrow_up_rounded,
                            color: isDark
                                ? AmomimusDarkTheme.policeLineYellow
                                : AmomimusDarkTheme.primaryPurple,
                            size: 49,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          drawer: Drawer(
            width: MediaQuery.of(context).size.width * 0.7,
            backgroundColor: isDark
                ? AmomimusDarkTheme.backgroundDark
                : Colors.white,
            child: Builder(
              builder: (context) {
                final lang = context.watch<LanguageManager>();
                final headerColor = currentUser != null ? GenderHelpers.getGenderColor(currentUser.gender) : AmomimusDarkTheme.primaryPurple;
                final isBright = headerColor.computeLuminance() > 0.5;
                final headerTextColor = isBright ? Colors.black87 : Colors.white;
                final subTextColor = isBright ? Colors.black54 : Colors.white70;

                return Column(
                  children: [
                    Material(
                      color: headerColor,
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(24, 70, 24, 30),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.white,
                                  child: Icon(
                                    currentUser != null ? GenderHelpers.getGenderIcon(currentUser.gender) : Icons.person,
                                    size: 50,
                                    color: headerColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                currentUser?.customUsername ?? currentUser?.anonymousUsername ?? "User",
                                style: TextStyle(
                                  color: headerTextColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (currentUser != null && currentUser.customUsername != null && currentUser.customUsername!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "${lang.getString('public_name')}: ${currentUser.anonymousUsername}",
                                  style: TextStyle(
                                    color: subTextColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 4),
                              Text(
                                currentUser?.amomimusId ?? "#AMM-000",
                                style: TextStyle(
                                  color: subTextColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.help_outline,
                        color: isDark ? AmomimusDarkTheme.textSecondary : Colors.grey,
                      ),
                      title: Text(
                        lang.getString('app_doc'),
                        style: TextStyle(
                          color: isDark
                              ? AmomimusDarkTheme.textPrimary
                              : Colors.black,
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.contact_mail_outlined,
                        color: isDark ? AmomimusDarkTheme.textSecondary : Colors.grey,
                      ),
                      title: Text(
                        lang.getString('contact_dev'),
                        style: TextStyle(
                          color: isDark
                              ? AmomimusDarkTheme.textPrimary
                              : Colors.black,
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.language,
                        color: isDark ? AmomimusDarkTheme.textSecondary : Colors.grey,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            lang.getString('language'),
                            style: TextStyle(
                              color: isDark ? AmomimusDarkTheme.textPrimary : Colors.black,
                            ),
                          ),
                          DropdownButton<String>(
                            value: lang.dropdownValue,
                            dropdownColor: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
                            style: TextStyle(
                              color: isDark ? AmomimusDarkTheme.textPrimary : Colors.black,
                            ),
                            underline: const SizedBox(),
                            icon: Icon(Icons.arrow_drop_down, color: isDark ? AmomimusDarkTheme.textSecondary : Colors.grey),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                lang.setLanguageFromDropdown(newValue);
                              }
                            },
                            items: <String>['Bahasa', 'English', '忍者', 'Tamriel']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.bug_report_outlined,
                        color: isDark ? AmomimusDarkTheme.textSecondary : Colors.grey,
                      ),
                      title: Text(
                        lang.getString('report_bug'),
                        style: TextStyle(
                          color: isDark
                              ? AmomimusDarkTheme.textPrimary
                              : Colors.black,
                        ),
                      ),
                      onTap: () {},
                    ),
                    const Spacer(),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: Text(
                        lang.getString('exit'),
                        style: const TextStyle(color: Colors.red),
                      ),
                      onTap: () async {
                        await PreferenceHandler.logOut();
                        if (!context.mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const AmomimusApp2(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }
            ),
          ),
        ),
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
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);

    for (double i = size.width; i >= 0; i--) {
      double angle =
          (animationValue * 2 * pi) + (i / size.width * 2 * pi) + (offset * pi);
      double y = sin(angle) * 12 + 35;
      path.lineTo(i, y);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class FeedCard extends StatefulWidget {
  final FeedModel model;
  final int feedIndex;

  const FeedCard({super.key, required this.model, required this.feedIndex});

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  bool isMenuOpen = false;

  void _showCommentsSheet(BuildContext context, bool isDarkCard, UserAccount? currentUser) {
    final commentController = TextEditingController();
    CommentModel? replyTarget;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkCard ? AmomimusDarkTheme.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16, right: 16, top: 16,
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.watch<LanguageManager>().getString('comments'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkCard ? Colors.white : Colors.black)),
              const SizedBox(height: 16),
              if (widget.model.comments.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(context.watch<LanguageManager>().getString('no_comments')),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.model.comments.length,
                  itemBuilder: (context, index) {
                    final comment = widget.model.comments[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                      title: Text("${comment.authorName} (${comment.authorId})", style: TextStyle(fontWeight: FontWeight.bold, color: isDarkCard ? Colors.white70 : Colors.black87, fontSize: 12)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (comment.replyToName != null && comment.replyToText != null)
                            Container(
                              margin: const EdgeInsets.only(top: 4, bottom: 4),
                              padding: const EdgeInsets.only(left: 8),
                              decoration: const BoxDecoration(
                                border: Border(left: BorderSide(color: Colors.grey, width: 2)),
                              ),
                              child: Text(
                                "${context.watch<LanguageManager>().getString('replying_to')} ${comment.replyToName}:\n${comment.replyToText}",
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          Text(comment.text, style: TextStyle(color: isDarkCard ? Colors.white : Colors.black)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(targetUserId: comment.authorId),
                          ),
                        );
                      },
                      onLongPress: () {
                        setSheetState(() {
                          replyTarget = comment;
                        });
                      },
                    );
                  },
                ),
              const Divider(),
              if (replyTarget != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  color: isDarkCard ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${context.watch<LanguageManager>().getString('replying_to')} ${replyTarget!.authorName}:\n${replyTarget!.text}",
                          style: TextStyle(fontSize: 12, color: isDarkCard ? Colors.white70 : Colors.black54),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          setSheetState(() {
                            replyTarget = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      style: TextStyle(color: isDarkCard ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        hintText: context.watch<LanguageManager>().getString('add_comment'),
                        hintStyle: TextStyle(color: isDarkCard ? Colors.white54 : Colors.black54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: AmomimusDarkTheme.primaryPurple),
                    onPressed: () {
                      if (commentController.text.trim().isNotEmpty && currentUser != null) {
                        final generatedName = AnonymousNames.getConsistentNameForPost(currentUser.amomimusId, widget.model.id);
                        final newComment = CommentModel(
                          authorId: currentUser.amomimusId,
                          authorName: generatedName,
                          text: commentController.text,
                          timeStamp: "Just now",
                          replyToName: replyTarget?.authorName,
                          replyToText: replyTarget?.text,
                        );
                        Provider.of<FeedManager>(context, listen: false).addComment(widget.model.id, newComment);
                        
                        final notifManager = Provider.of<NotificationManager>(context, listen: false);
                        if (replyTarget != null && replyTarget?.authorId != currentUser.amomimusId) {
                          notifManager.addNotification(NotificationModel(
                            targetUserId: replyTarget!.authorId,
                            actorName: generatedName,
                            type: NotificationType.reply,
                            feedId: widget.model.id,
                            message: "replied to your comment",
                          ));
                        } else if (widget.model.realAuthorId != null && widget.model.realAuthorId != currentUser.amomimusId) {
                          notifManager.addNotification(NotificationModel(
                            targetUserId: widget.model.realAuthorId!,
                            actorName: generatedName,
                            type: NotificationType.comment,
                            feedId: widget.model.id,
                            message: "commented on your post",
                          ));
                        }
                        
                        commentController.clear();
                        setState(() {
                          replyTarget = null;
                        });
                      }
                    },
                  )
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
        },
      );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final amomimusTheme = Provider.of<AmomimusDarkTheme>(context);
    final isDarkCard = amomimusTheme.isDarkMode;
    final currentUser = Provider.of<AccountManager>(context).currentUser;
    final userId = currentUser?.amomimusId ?? "unknown";
    
    final isResonated = widget.model.resonatedBy.contains(userId);
    final displayResonateCount = widget.model.resonatedBy.length;
    final displayCommentCount = widget.model.comments.length;
    final hasUserCommented = widget.model.comments.any((c) => c.authorId == userId);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkCard ? const Color(0xFF121212) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkCard
              ? AmomimusDarkTheme.policeLineYellow
              : AmomimusDarkTheme.primaryPurple,
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          final realId = widget.model.realAuthorId ?? widget.model.id;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(targetUserId: realId, feedModel: widget.model),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              GenderHelpers.getTypeIcon(widget.model.type),
                              color: GenderHelpers.getTypeColor(widget.model.type),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.model.id,
                              style: GenderHelpers.getTypeIdTextStyle(widget.model.type).copyWith(
                                color: GenderHelpers.getTypeColor(widget.model.type),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.model.timeStamp,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkCard
                              ? AmomimusDarkTheme.textSecondary
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Theme(
                        data: Theme.of(context).copyWith(
                          popupMenuTheme: PopupMenuThemeData(
                            color: isDarkCard
                                ? AmomimusDarkTheme.policeLineYellow
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        child: PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            size: 18,
                            color: isDarkCard
                                ? AmomimusDarkTheme.textSecondary
                                : Colors.grey,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 140,
                            maxWidth: 190,
                          ),
                          onOpened: () {
                            setState(() => isMenuOpen = true);
                          },
                          onCanceled: () {
                            setState(() => isMenuOpen = false);
                          },
                          onSelected: (value) async {
                            setState(() => isMenuOpen = false);
                            final realId = widget.model.realAuthorId ?? widget.model.id;
                            final realName = widget.model.realAuthorName ?? widget.model.userName;

                            if (value == 'chat') {
                              final reqManager = Provider.of<ChatRequestManager>(context, listen: false);
                              final currentUserAcc = currentUser;
                              if (currentUserAcc == null) return;
                              
                              if (reqManager.isChatAllowed(realId) || context.read<ChatModel>().getChatByUsername(realId).messages.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AmomimusApp6(username: realId, name: realName),
                                  ),
                                );
                                return;
                              }

                              if (reqManager.hasPendingRequestWith(realId)) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.read<LanguageManager>().getString('chat_req_pending'))));
                                return;
                              }

                              if (currentUserAcc.reportedCount > 5) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.read<LanguageManager>().getString('indicator_noise_limit'))));
                                return;
                              }
                              
                              if (currentUserAcc.reportedCount > 0 && currentUserAcc.reportedCount <= 5) {
                                final today = DateTime.now().toIso8601String().split('T').first;
                                final lastReqDate = currentUserAcc.lastChatRequestDate?.split('T').first;
                                int sentToday = currentUserAcc.dailyChatRequestsSent;
                                
                                if (lastReqDate != today) {
                                  sentToday = 0;
                                }
                                
                                if (sentToday >= 7) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.read<LanguageManager>().getString('ghost_limit_reached'))));
                                  return;
                                }
                              }

                              final bool? confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) {
                                  final themeProvider = Provider.of<AmomimusDarkTheme>(ctx, listen: false);
                                  final isDark = themeProvider.isDarkMode;
                                  final bgCol = isDark ? AmomimusDarkTheme.surfaceDark : Colors.white;
                                  final textCol = isDark ? Colors.white : Colors.black87;
                                  final textSecCol = isDark ? AmomimusDarkTheme.textSecondary : Colors.black54;

                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: bgCol,
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: isDark ? Colors.white12 : Colors.black12,
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                                            blurRadius: 24,
                                            offset: const Offset(0, 12),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.chat_bubble_outline_rounded,
                                            size: 48,
                                            color: AmomimusDarkTheme.primaryPurple,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            context.read<LanguageManager>().getString('initiate_chat'),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: textCol,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            '${context.read<LanguageManager>().getString('confirm_chat')}${currentUser?.anonymousUsername ?? "Anonymous"}.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: textSecCol,
                                              height: 1.4,
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextButton(
                                                  onPressed: () => Navigator.pop(ctx, false),
                                                  style: TextButton.styleFrom(
                                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    context.read<LanguageManager>().getString('cancel'),
                                                    style: TextStyle(
                                                      color: textSecCol,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () => Navigator.pop(ctx, true),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: AmomimusDarkTheme.primaryPurple,
                                                    foregroundColor: Colors.white,
                                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                                    elevation: 0,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    context.read<LanguageManager>().getString('send_request'),
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );

                              if (confirm == true && mounted) {
                                reqManager.sendRequest(realId, realName, currentUserAcc.anonymousUsername);
                                context.read<AccountManager>().incrementChatRequestCount();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(context.read<LanguageManager>().getString('chat_req_sent'))),
                                );
                              }
                            } else if (value == 'delete') {
                              Provider.of<FeedManager>(context, listen: false).deletePost(widget.feedIndex);
                            } else if (value == 'hide') {
                              Provider.of<AccountManager>(context, listen: false).hideFeed(widget.model.id);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.read<LanguageManager>().getString('feed_hidden'))));
                            } else if (value == 'report') {
                              showDialog(
                                context: context,
                                builder: (context) => ReportDialog(
                                  targetId: realId,
                                  isUserReport: true,
                                ),
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            final contentColor = isDarkCard
                                ? Colors.black
                                : Colors.black87;
                            final reportColor = isDarkCard
                                ? const Color(0xFFB00020)
                                : Colors.red;

                            return <PopupMenuEntry<String>>[
                              if (currentUser?.amomimusId != (widget.model.realAuthorId ?? widget.model.id))
                                PopupMenuItem<String>(
                                  value: 'chat',
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.chat_bubble_outline,
                                      color: contentColor,
                                    ),
                                    title: Text(
                                      context.watch<LanguageManager>().getString('chat_this_amomim'),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: contentColor,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              if (currentUser?.amomimusId == (widget.model.realAuthorId ?? widget.model.id))
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.delete_outline,
                                      color: reportColor,
                                    ),
                                    title: Text(
                                      context.watch<LanguageManager>().getString('delete_post'),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: reportColor,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              if (currentUser?.amomimusId != (widget.model.realAuthorId ?? widget.model.id))
                                PopupMenuItem<String>(
                                  value: 'hide',
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.visibility_off_outlined,
                                      color: contentColor,
                                    ),
                                    title: Text(
                                      context.watch<LanguageManager>().getString('hide_feed'),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: contentColor,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              if (currentUser?.amomimusId != (widget.model.realAuthorId ?? widget.model.id))
                                PopupMenuItem<String>(
                                  value: 'report',
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.sentiment_very_dissatisfied_outlined,
                                      color: reportColor,
                                    ),
                                    title: Text(
                                      context.watch<LanguageManager>().getString('report_amomim'),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: reportColor,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                            ];
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.model.content,
                    style: const TextStyle(fontSize: 15, height: 1.4).copyWith(
                      color: isDarkCard ? AmomimusDarkTheme.textPrimary : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Provider.of<FeedManager>(context, listen: false).toggleResonate(widget.model.id, userId);
                          if (!isResonated && widget.model.realAuthorId != null && widget.model.realAuthorId != userId) {
                            Provider.of<NotificationManager>(context, listen: false).addNotification(NotificationModel(
                              targetUserId: widget.model.realAuthorId!,
                              actorName: currentUser?.anonymousUsername ?? "Someone",
                              type: NotificationType.resonate,
                              feedId: widget.model.id,
                              message: "resonated your post",
                            ));
                          }
                        },
                        child: _buildButton(
                          isResonated ? Icons.favorite : Icons.favorite_border,
                          "$displayResonateCount ${isResonated ? context.watch<LanguageManager>().getString('resonated') : context.watch<LanguageManager>().getString('resonates')}",
                          isResonated
                              ? Colors.red
                              : (isDarkCard
                                    ? AmomimusDarkTheme.textSecondary
                                    : Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () => _showCommentsSheet(context, isDarkCard, currentUser),
                        child: Container(
                          padding: hasUserCommented
                              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6)
                              : EdgeInsets.zero,
                          decoration: hasUserCommented
                              ? BoxDecoration(
                                  color: const Color(0xFFFFD54F),
                                  borderRadius: BorderRadius.circular(16),
                                )
                              : null,
                          child: _buildButton(
                            Icons.chat_bubble_outline,
                            "$displayCommentCount ${context.watch<LanguageManager>().getString('comments')}",
                            hasUserCommented
                                ? const Color(0xFF8D5A19)
                                : (isDarkCard
                                    ? AmomimusDarkTheme.textSecondary
                                    : Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. BLUR OVERLAY DI-RENDER TERAKHIR (Menutup konten di bawahnya)
            if (isMenuOpen)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    // Menggunakan warna semi transparan agar efek blur terasa nyata
                    color: isDarkCard
                        ? Colors.black.withOpacity(0.4)
                        : Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: icon == Icons.favorite
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
