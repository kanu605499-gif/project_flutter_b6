import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'amomimusdark.dart';
import 'chatmodel.dart';

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
  const AmomimusApp6({super.key, this.username});

  @override
  State<AmomimusApp6> createState() => _AmomimusApp6State();
}

class _AmomimusApp6State extends State<AmomimusApp6>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  double _headerOpacity = 0.0;
  bool _isIslandExpanded = false;

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
        double linearOpacity = ((pixels - 70) / 80).clamp(0.0, 1.0).toDouble();

        setState(() {
          _headerOpacity = Curves.easeInOut.transform(linearOpacity);
          if (pixels > 15 && _isIslandExpanded) {
            _isIslandExpanded = false;
          }
        });
      } catch (_) {
        setState(() {
          _headerOpacity = 0.0;
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

      context.read<ChatModel>().sendMessage(username, text);
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AmomimusDarkTheme>();
    final chatModel = context.watch<ChatModel>();
    final activeChat = chatModel.getChatByUsername(
      widget.username ?? '@partner_dev',
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

    Widget expandableMiniIsland() {
      final Color dynamicOutlineColor = themeProvider.isDarkMode
          ? Colors.white.withOpacity(0.2)
          : Colors.black87.withOpacity(0.15);

      final Color islandBg = themeProvider.isDarkMode
          ? currentSurface.withOpacity(0.9)
          : Colors.grey[100]!.withOpacity(0.95);

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
          width: _isIslandExpanded ? 195 : 46,
          decoration: BoxDecoration(
            color: islandBg,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: dynamicOutlineColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  themeProvider.isDarkMode ? 0.3 : 0.08,
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
                    Icons.person_rounded,
                    color: themeProvider.isDarkMode
                        ? AmomimusDarkTheme.policeLineYellow
                        : AmomimusDarkTheme.primaryPurple,
                    size: 22,
                  ),
                ),
              ),
              secondChild: Container(
                width: 195,
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
                            child: const Icon(
                              Icons.person,
                              color: Color(0xFFFFD700),
                              size: 16,
                            ),
                          ),
                          Positioned(
                            bottom: -0.5,
                            right: -0.5,
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                color: activeChat.isOnline
                                    ? Colors.green
                                    : Colors.grey,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: themeProvider.isDarkMode
                                      ? currentSurface
                                      : Colors.grey[100]!,
                                  width: 1.2,
                                ),
                              ),
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
                            activeChat.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                          Text(
                            activeChat.isOnline ? "Online" : "Offline",
                            style: TextStyle(
                              fontSize: 8,
                              color: activeChat.isOnline
                                  ? (themeProvider.isDarkMode
                                        ? Colors.greenAccent
                                        : Colors.green[700])
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
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
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AmomimusDarkTheme.policeLineYellow,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: AmomimusDarkTheme.policeLineYellow,
                    size: 38,
                  ),
                ),
                if (activeChat.isOnline)
                  Positioned(
                    bottom: -2,
                    right: -2,
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
            const SizedBox(height: 14),
            Text(
              activeChat.name,
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
                          child: ClipPath(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            clipper: AmomimusWaveClipper(
                              _waveController.value,
                              0.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    dynamicAccentColor.withOpacity(0.35),
                                    dynamicAccentColor.withOpacity(0.02),
                                  ],
                                ),
                              ),
                            ),
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
                                    return MessageBubble(
                                      message: messages[index - 1],
                                    );
                                  }, childCount: messages.length + 1),
                                ),
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
                                      hintText: "Tulis pesan...",
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
                  if (_headerOpacity > 0.0)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Opacity(
                          opacity: _headerOpacity,
                          child: Container(
                            margin: EdgeInsets.only(top: statusBarHeight + 10),
                            child: expandableMiniIsland(),
                          ),
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

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AmomimusDarkTheme>();
    final isDark = themeProvider.isDarkMode;
    Color bubbleColor = isDark ? AmomimusDarkTheme.surfaceDark : Colors.white;
    final Color customBorderColor = message.isUser
        ? AmomimusDarkTheme.policeLineYellow
        : AmomimusDarkTheme.primaryPurple;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color textSecondaryColor = isDark
        ? AmomimusDarkTheme.textSecondary
        : Colors.black54;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 11.0),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message.isUser) ...[
            Text(
              message.timeStamp,
              style: TextStyle(
                fontSize: 9,
                color: textSecondaryColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(width: 8),
          ],
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.62,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: message.isUser
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: message.isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
                border: Border.all(
                  color: customBorderColor.withOpacity(0.7),
                  width: 1.85,
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  height:
                      1.5, // Diubah ke 1.5 biar space line liriknya ga terlalu renggang dan makan space
                  fontFamily: 'serif',
                ),
              ),
            ),
          ),
          if (!message.isUser) ...[
            const SizedBox(width: 8),
            Text(
              message.timeStamp,
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
