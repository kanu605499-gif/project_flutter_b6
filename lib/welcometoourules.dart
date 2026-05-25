import 'package:flutter/material.dart';
import 'package:project_flutter_b6/tugas9ui.dart';

class AmomimusApp4 extends StatefulWidget {
  const AmomimusApp4({super.key});

  @override
  State<AmomimusApp4> createState() => _AmomimusApp4State();
}

class _AmomimusApp4State extends State<AmomimusApp4> {
  int _currentIndex = 0;
  bool _isDarkMode = false;

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color mainTextColor = _isDarkMode
        ? Colors.white
        : const Color(0xff121212);
    final Color scaffoldBg = _isDarkMode
        ? const Color(0xff121212)
        : const Color(0xfffdfbfe);
    final Color navBg = _isDarkMode ? const Color(0xff1e1b24) : Colors.white;
    final Color borderColor = _isDarkMode
        ? const Color(0xff3d344d)
        : const Color(0xffe1dbec);

    final List<Widget> pages = [
      AmomimusFormPage(
        isDarkMode: _isDarkMode,
        onThemeChanged: _toggleDarkMode,
      ),
      AboutPage(
        isDarkMode: _isDarkMode,
        onBackToPrivacy: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
    ];

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            text: _currentIndex == 0 ? 'Privacy ' : 'About ',
            style: TextStyle(
              color: mainTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Sans-Serif',
            ),
            children: [
              TextSpan(
                text: _currentIndex == 0 ? 'Policy' : 'Amomimus',
                style: TextStyle(color: const Color(0xff8c72c4)),
              ),
            ],
          ),
        ),
        backgroundColor: navBg,
        elevation: 0,
        iconTheme: IconThemeData(color: mainTextColor),
        automaticallyImplyLeading: false,
        leading: _currentIndex == 0
            ? Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            : null,
      ),
      drawer: _currentIndex == 0
          ? Drawer(
              child: Container(
                color: navBg,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(color: Color(0xff6c52a3)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Amomimus Center',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'For Help and Support Queries',
                            style: TextStyle(
                              color: Color(0xfff1c66a),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        'HELP & SUPPORT',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.help_outline,
                        color: Color(0xff8c72c4),
                      ),
                      title: Text(
                        'App Documentation',
                        style: TextStyle(color: mainTextColor),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.bug_report_outlined,
                        color: Color(0xff8c72c4),
                      ),
                      title: Text(
                        'Report a Bug / Glitch',
                        style: TextStyle(color: mainTextColor),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.contact_page_rounded,
                        color: Color(0xff8c72c4),
                      ),
                      title: Text(
                        'Contact Developers',
                        style: TextStyle(color: mainTextColor),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    Divider(color: borderColor, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.redAccent,
                      ),
                      title: const Text(
                        'Exit Session',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: navBg,
        selectedItemColor: const Color(0xff8c72c4),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shield_outlined),
            label: 'Privacy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'About',
          ),
        ],
      ),
    );
  }
}

class AmomimusFormPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const AmomimusFormPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<AmomimusFormPage> createState() => _AmomimusFormPageState();
}

class _AmomimusFormPageState extends State<AmomimusFormPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatingController;
  bool _hasAcceptedTerms = false;
  String _selectedLanguage = 'Bahasa';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  String _getFormattedDate() {
    if (_selectedDate == null) return 'Pick Date';
    final day = _selectedDate!.day.toString().padLeft(2, '0');
    final month = _selectedDate!.month.toString().padLeft(2, '0');
    final year = _selectedDate!.year;
    return _selectedLanguage == 'English'
        ? '$month/$day/$year'
        : '$day/$month/$year';
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            brightness: widget.isDarkMode ? Brightness.dark : Brightness.light,
            colorScheme: widget.isDarkMode
                ? const ColorScheme.dark(
                    primary: Color(0xfff1c66a),
                    onPrimary: Colors.black,
                    surface: Color(0xff1e1b24),
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: Color(0xff6c52a3),
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black,
                  ),
            dialogTheme: DialogThemeData(
              backgroundColor: widget.isDarkMode
                  ? const Color(0xff1e1b24)
                  : Colors.white,
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
              bodyMedium: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
              titleMedium: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
              hintStyle: TextStyle(
                color: widget.isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: widget.isDarkMode
                      ? const Color(0xfff1c66a)
                      : const Color(0xff6c52a3),
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color currentCardBg = widget.isDarkMode
        ? const Color(0xff1e1b24)
        : Colors.white;
    final Color mainTextColor = widget.isDarkMode
        ? Colors.white
        : const Color(0xff121212);
    final Color subTextColor = widget.isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[700]!;
    final Color borderColor = widget.isDarkMode
        ? const Color(0xff3d344d)
        : const Color(0xffe1dbec);

    return Stack(
      children: [
        Positioned(
          top: -39,
          right: -40,
          child: AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  0,
                  -12 * Curves.easeInOut.transform(_floatingController.value),
                ),
                child: Transform.rotate(angle: 0.15, child: child),
              );
            },
            child: _buildFloatingContainer(
              bgColor: widget.isDarkMode
                  ? const Color(0x2F252030)
                  : const Color.fromARGB(255, 250, 246, 255),
              icon: Icons.diamond_outlined,
              iconColor: widget.isDarkMode
                  ? const Color(0xff9a82c7)
                  : const Color.fromARGB(255, 215, 192, 255),
            ),
          ),
        ),
        Positioned(
          top: 125,
          bottom: 125,
          left: 25,
          right: 15,
          child: AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  0,
                  -12 * Curves.easeInOut.transform(_floatingController.value),
                ),
                child: Transform.rotate(angle: 0.15, child: child),
              );
            },
            child: Center(
              child: _buildFloatingContainer(
                bgColor: widget.isDarkMode
                    ? const Color.fromARGB(29, 58, 53, 37)
                    : const Color.fromARGB(255, 255, 251, 240),
                icon: Icons.android_outlined,
                iconColor: widget.isDarkMode
                    ? const Color.fromARGB(255, 241, 198, 106)
                    : const Color(0xFFFFD54F),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -59,
          left: -35,
          child: AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  0,
                  -12 * Curves.easeInOut.transform(_floatingController.value),
                ),
                child: Transform.rotate(angle: -0.15, child: child),
              );
            },
            child: Center(
              child: _buildFloatingContainer(
                bgColor: widget.isDarkMode
                    ? const Color.fromARGB(29, 58, 53, 37)
                    : const Color(0xFFF8F8F8),
                icon: Icons.water_outlined,
                iconColor: widget.isDarkMode
                    ? const Color(0xFFE0E0E0)
                    : const Color(0xFFE0E0E0),
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  top: 16.0,
                  right: 24.0,
                ),
                child: RichText(
                  text: TextSpan(
                    text: 'Terms of ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: mainTextColor,
                      fontFamily: 'Sans-Serif',
                    ),
                    children: const [
                      TextSpan(
                        text: 'Amomimus ',
                        style: TextStyle(color: Color(0xff8c72c4)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 485,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: currentCardBg.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Privacy & Rules Agreement',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff8c72c4),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Last updated: May 2026\n\n'
                        '1. Keep It Ghostly\n'
                        'You\'re a ghost here, bud. No real names, no phone numbers, and definitely no leaking your ex\'s address or social media handles. We want this space to be completely detached from your real-world drama.\n\n'
                        'If you accidentally slip up and reveal your true identity or doxx someone else, don\'t expect a warning. We will scrub that post faster than you can blink, and your access might vanish along with it. Keep it 100% incognito.\n\n'
                        '2. Don\'t Be a Total Jerk\n'
                        'Ranting? Cool. Crying? We got you. Venting about how much your job or life sucks is exactly why we built this app, so feel free to let off some steam without holding back.\n\n'
                        'But throwing straight-up hate speech, targeted harassment, or bullying someone who is already down? Nah, that\'s a fast pass to getting booted. There is a very clear line between venting your pain and just being a miserable troll.\n\n'
                        '3. Zero Data Retention\n'
                        'We don\'t buy, sell, or even care about your personal data. What happens in Amomimus, stays in Amomimus. Your temporary sessions are encrypted and will be wiped clean periodically from our servers.\n\n'
                        '4. No Commercial Spamming\n'
                        'This platform is made for human emotions, not for selling your crypto coins, promoting your online shop, or spamming affiliate links. Commercial ads without permission will result in an immediate hardware ban.\n\n'
                        '5. Age Restriction\n'
                        'Users must be at least 18 years old to participate in this blind community. The contents shared here can be mature, heavy, and raw. Protect your own mental health before reading others\' rants.\n\n'
                        '6. Content Ownership Disclaimer\n'
                        'You own the words you write, but by posting them here, you grant Amomimus a non-exclusive right to display them anonymously within the app interface. We will never claim your stories as our corporate property.\n\n'
                        '7. Report and Moderation System\n'
                        'Even ghosts have boundaries. If you find a post that violates our community safety guidelines, use the report feature immediately. Our automated system and moderators review flags 24/7.\n\n'
                        '8. Illegal Activities Ban\n'
                        'Do not use this app to plan, coordinate, or promote any form of illegal activities, physical violence, or real-world harm. We comply with digital safety regulations and will take strict action against violations.\n\n'
                        '9. Application Analytics\n'
                        'We only collect anonymous technical logs (such as crash reports, device model, and system language) to ensure the app runs smoothly on your phone. None of these logs can be traced back to your real identity.\n\n'
                        '10. Changes to the Terms\n'
                        'Amomimus reserves the right to update these rules anytime to adapt to new laws or features. Continued use of the app after updates means you agree to follow the latest ghostly protocols.',
                        style: TextStyle(
                          fontSize: 14,
                          color: subTextColor,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Amomimus System Language:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: mainTextColor,
                          ),
                        ),
                        DropdownButton<String>(
                          value: _selectedLanguage,
                          dropdownColor: currentCardBg,
                          style: TextStyle(
                            color: mainTextColor,
                            fontFamily: 'Sans-Serif',
                          ),
                          underline: Container(
                            height: 0.7,
                            color: const Color(0xff8c72c4),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedLanguage = newValue!;
                            });
                          },
                          items: <String>['Bahasa', 'English', '忍者', 'Tamriel']
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              })
                              .toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Verification Date:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: mainTextColor,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _pickDate(context),
                          icon: const Icon(
                            Icons.calendar_month,
                            size: 18,
                            color: Color(0xff8c72c4),
                          ),
                          label: Text(
                            _getFormattedDate(),
                            style: const TextStyle(color: Color(0xff8c72c4)),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: borderColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 32, color: borderColor),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: Text(
                              _hasAcceptedTerms
                                  ? 'Agreement verified'
                                  : 'Ready to verified our terms?',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _hasAcceptedTerms
                                    ? const Color(0xff8c72c4)
                                    : Colors.grey[600],
                              ),
                            ),
                            value: _hasAcceptedTerms,
                            activeColor: const Color(0xff8c72c4),
                            checkColor: Colors.white,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (bool? value) {
                              setState(() {
                                _hasAcceptedTerms = value ?? false;
                              });
                            },
                          ),
                        ),
                        Transform.scale(
                          scale: 0.85,
                          child: Switch(
                            value: widget.isDarkMode,
                            activeThumbColor: const Color(0xff8c72c4),
                            activeTrackColor: const Color(
                              0xff8c72c4,
                            ).withOpacity(0.4),
                            onChanged: widget.onThemeChanged,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _hasAcceptedTerms
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AmomimusApp5(),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff6c52a3),
                          disabledBackgroundColor: widget.isDarkMode
                              ? Colors.grey[800]
                              : Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Accept & Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _hasAcceptedTerms
                                ? Colors.white
                                : Colors.grey[600],
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
      ],
    );
  }

  Widget _buildFloatingContainer({
    required Color bgColor,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: 140,
      height: 160,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(child: Icon(icon, size: 48, color: iconColor)),
    );
  }
}

class AboutPage extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback? onBackToPrivacy;

  const AboutPage({super.key, required this.isDarkMode, this.onBackToPrivacy});

  @override
  Widget build(BuildContext context) {
    final Color mainTextColor = isDarkMode
        ? Colors.white
        : const Color(0xff121212);
    final Color subTextColor = isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[700]!;
    final Color cardBg = isDarkMode ? const Color(0xff1e1b24) : Colors.white;
    final Color borderColor = isDarkMode
        ? const Color(0xff3d344d)
        : const Color(0xffe1dbec);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (onBackToPrivacy != null) {
          onBackToPrivacy!();
        }
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.alternate_email_outlined,
                  size: 64,
                  color: Color(0xff8c72c4),
                ),
                const SizedBox(height: 16),
                Text(
                  'Amomimus Mobile App',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: mainTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A secure and a room of anonymous venting platform designed for digital catharsis.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: subTextColor,
                    height: 1.4,
                  ),
                ),
                const Divider(height: 32, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Developer:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: mainTextColor,
                      ),
                    ),
                    const Text(
                      'Kanu',
                      style: TextStyle(
                        color: Color(0xff8c72c4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'App Version:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: mainTextColor,
                      ),
                    ),
                    Text(
                      'v1.0.8 (Tugas 8)',
                      style: TextStyle(color: Color(0xfff1c66a)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
