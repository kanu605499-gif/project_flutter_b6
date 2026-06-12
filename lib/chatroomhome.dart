import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'account_manager.dart';
import 'database_helper.dart';

import 'amomimusdark.dart';
import 'chatmodel.dart';
import 'roomchat.dart';

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

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

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
    super.dispose();
  }

  void _showAccountSwitcher(BuildContext context, AmomimusDarkTheme themeProvider) {
    final accountManager = context.read<AccountManager>();
    final currentBg = themeProvider.isDarkMode
        ? AmomimusDarkTheme.surfaceDark
        : Colors.white;
    final textColor = themeProvider.isDarkMode ? Colors.white : Colors.black87;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: currentBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Text("Switch Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: accountManager.accounts.length,
                  itemBuilder: (context, index) {
                    final acc = accountManager.accounts[index];
                    return ListTile(
                      title: Text(acc.anonymousUsername, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        acc.isDemo ? "Demo Account" : "Dummy Account",
                        style: TextStyle(color: textColor.withOpacity(0.6)),
                      ),
                      trailing: accountManager.currentUser?.id == acc.id
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        accountManager.switchAccount(acc);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Switched to ${acc.anonymousUsername}'), duration: const Duration(seconds: 1)),
                        );
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
                      context.watch<AccountManager>().currentUser?.anonymousUsername ?? "Messages",
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
                                "Amomus List",
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
                                icon: const Icon(Icons.manage_accounts_rounded),
                                color: dynamicAccentColor,
                                onPressed: () {
                                  _showAccountSwitcher(context, themeProvider);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // List Orang Menggunakan Kustom ListTile dengan Border Melengkung
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

    // Border kuning untuk user, ungu untuk partner (senada dengan vibes bubble chat)
    final Color customBorderColor =
        (chat.name == "Partner" || chat.unreadCount > 0)
        ? AmomimusDarkTheme.policeLineYellow
        : AmomimusDarkTheme.primaryPurple;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          context.read<ChatModel>().markAsRead(chat.username);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AmomimusApp6(username: chat.username),
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
                      border: Border.all(
                        color: AmomimusDarkTheme.policeLineYellow,
                        width: 1.2,
                      ),
                    ),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: AmomimusDarkTheme.policeLineYellow,
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
                          chat.name,
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
