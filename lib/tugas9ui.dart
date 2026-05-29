import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_flutter_b6/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'amomimusdark.dart';
import 'tugas9model.dart';

class AmomimusApp5 extends StatefulWidget {
  const AmomimusApp5({super.key});

  @override
  State<AmomimusApp5> createState() => _AmomimusApp5State();
}

class _AmomimusApp5State extends State<AmomimusApp5>
    with TickerProviderStateMixin {
  late List<FeedModel> feedData;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _waveController;
  final TextEditingController _postController = TextEditingController();

  bool _isDarkModeLocal = true;

  @override
  void initState() {
    super.initState();
    try {
      feedData = FeedModel.generateDummyData();
    } catch (e) {
      feedData = [];
    }

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
    final userProfile = feedData.firstWhere(
      (f) => f.type == AccountType.user,
      orElse: () => FeedModel(
        id: "#YOU-000",
        userName: "User",
        type: AccountType.user,
        content: "",
        timeStamp: "",
        iconData: Icons.person,
        themeColor: Colors.purple,
        contentTextStyle: const TextStyle(),
        idTextStyle: const TextStyle(),
        resonateCount: 0,
        commentCount: 0,
      ),
    );

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
                    "Create a Post",
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
                      hintText: "What's on your mind anonymously?",
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
                          setState(() {
                            feedData.insert(
                              0,
                              FeedModel(
                                userName: userProfile.userName,
                                id: "#YOU-${Random().nextInt(900) + 100}",
                                type: AccountType.user,
                                content: _postController.text,
                                timeStamp: "Just now",
                                iconData: userProfile.iconData,
                                themeColor: userProfile.themeColor,
                                contentTextStyle: userProfile.contentTextStyle,
                                idTextStyle: userProfile.idTextStyle,
                                resonateCount: 0,
                                commentCount: 0,
                              ),
                            );
                          });
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
                      child: const Text(
                        "Send Post",
                        style: TextStyle(
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

  @override
  Widget build(BuildContext context) {
    final userProfile = feedData.firstWhere(
      (f) => f.type == AccountType.user,
      orElse: () => FeedModel(
        id: "#YOU-000",
        userName: "User",
        type: AccountType.user,
        content: "",
        timeStamp: "",
        iconData: Icons.person,
        themeColor: Colors.purple,
        contentTextStyle: const TextStyle(),
        idTextStyle: const TextStyle(),
        resonateCount: 0,
        commentCount: 0,
      ),
    );
    final isDark = _isDarkModeLocal;

    return Theme(
      data: isDark ? ThemeData.dark() : ThemeData.light(),
      child: Builder(
        builder: (context) {
          final currentScaffoldBg = isDark
              ? AmomimusDarkTheme.backgroundDark
              : Colors.grey[50]!;

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: isDark
                  ? Brightness.light
                  : Brightness.dark,
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
                        ? const Center(child: Text("No feeds available."))
                        : ListView.builder(
                            padding: const EdgeInsets.only(
                              top: 95,
                              bottom: 120,
                            ),
                            itemCount: feedData.length,
                            itemBuilder: (context, index) =>
                                FeedCard(model: feedData[index]),
                          ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 90,
                      padding: const EdgeInsets.only(
                        top: 30,
                        right: 16,
                        left: 16,
                      ),
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
                              setState(() {
                                _isDarkModeLocal = !_isDarkModeLocal;
                              });
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
                        color: isDark
                            ? AmomimusDarkTheme.surfaceDark
                            : Colors.white,
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
                            icon: Icon(
                              Icons.messenger_outline,
                              color: isDark
                                  ? AmomimusDarkTheme.policeLineYellow
                                  : AmomimusDarkTheme.primaryPurple,
                            ),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 60),
                          IconButton(
                            icon: Icon(
                              Icons.person_outline,
                              color: isDark
                                  ? AmomimusDarkTheme.policeLineYellow
                                  : AmomimusDarkTheme.primaryPurple,
                            ),
                            onPressed: () {},
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
                              onPressed: () =>
                                  _summonPostSheet(context, isDark),
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
                child: Column(
                  children: [
                    Material(
                      color: AmomimusDarkTheme.primaryPurple,
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
                                  child: const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: AmomimusDarkTheme.primaryPurple,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                userProfile.userName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userProfile.id,
                                style: const TextStyle(
                                  color: Colors.white70,
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
                        color: isDark
                            ? AmomimusDarkTheme.textSecondary
                            : Colors.grey,
                      ),
                      title: Text(
                        "App Documentation",
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
                        Icons.bug_report_outlined,
                        color: isDark
                            ? AmomimusDarkTheme.textSecondary
                            : Colors.grey,
                      ),
                      title: Text(
                        "Report a Bug",
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
                        color: isDark
                            ? AmomimusDarkTheme.textSecondary
                            : Colors.grey,
                      ),
                      title: Text(
                        "Contact Developers",
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
                      title: const Text(
                        "Exit Session",
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(color: Colors.red),
                          ),
                        );

                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isLoggedin', false);

                        if (!context.mounted) return;

                        Navigator.of(context, rootNavigator: true).pop();

                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const AmomimusApp2(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
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
  const FeedCard({super.key, required this.model});

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  bool isMenuOpen = false;
  bool isResonated = false;

  @override
  Widget build(BuildContext context) {
    final isDarkCard = Theme.of(context).brightness == Brightness.dark;
    final displayResonateCount = isResonated
        ? widget.model.resonateCount + 1
        : widget.model.resonateCount;

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: isDarkCard
              ? AmomimusDarkTheme.cardDecoration.copyWith(
                  border: Border.all(
                    color: AmomimusDarkTheme.policeLineYellow,
                    width: 1.5,
                  ),
                )
              : BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AmomimusDarkTheme.primaryPurple,
                    width: 1.5,
                  ),
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    widget.model.iconData,
                    color: widget.model.themeColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.model.id,
                    style: widget.model.idTextStyle.copyWith(
                      color: widget.model.themeColor,
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
                        minWidth: 120,
                        maxWidth: 180,
                      ),
                      onOpened: () => setState(() => isMenuOpen = true),
                      onCanceled: () => setState(() => isMenuOpen = false),
                      onSelected: (value) => setState(() => isMenuOpen = false),
                      itemBuilder: (BuildContext context) {
                        final contentColor = isDarkCard
                            ? Colors.black
                            : Colors.black87;
                        final reportColor = Colors.red;

                        return <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'chat',
                            child: ListTile(
                              leading: Icon(
                                Icons.chat_bubble_outline,
                                color: contentColor,
                              ),
                              title: Text(
                                "Chat this Amomim",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: contentColor,
                                ),
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'report',
                            child: ListTile(
                              leading: Icon(
                                Icons.sentiment_very_dissatisfied_outlined,
                                color: reportColor,
                              ),
                              title: Text(
                                "Report this Amomim",
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
              const SizedBox(height: 12),
              Text(
                widget.model.content,
                style: widget.model.contentTextStyle.copyWith(
                  color: isDarkCard ? AmomimusDarkTheme.textPrimary : null,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isResonated = !isResonated;
                      });
                    },
                    child: _buildButton(
                      isResonated ? Icons.favorite : Icons.favorite_border,
                      "$displayResonateCount ${isResonated ? 'Resonated' : 'Resonates'}",
                      isResonated
                          ? Colors.red
                          : (isDarkCard
                                ? AmomimusDarkTheme.textSecondary
                                : Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 20),
                  _buildButton(
                    Icons.chat_bubble_outline,
                    "${widget.model.commentCount} Comments",
                    isDarkCard ? AmomimusDarkTheme.textSecondary : Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isMenuOpen)
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    color: isDarkCard
                        ? AmomimusDarkTheme.blurOverlayColor
                        : Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ),
      ],
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
