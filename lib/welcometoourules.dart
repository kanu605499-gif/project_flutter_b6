import 'package:flutter/material.dart';

class AmomimusApp4 extends StatefulWidget {
  const AmomimusApp4({super.key});

  @override
  State<AmomimusApp4> createState() => _AmomimusApp4State();
}

class _AmomimusApp4State extends State<AmomimusApp4>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatingController;
  bool _hasAcceptedTerms = false;
  bool _isDarkMode = false;
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

    if (_selectedLanguage == 'English') {
      return '$month/$day/$year';
    }
    return '$day/$month/$year';
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
            brightness: _isDarkMode ? Brightness.dark : Brightness.light,
            colorScheme: _isDarkMode
                ? const ColorScheme.dark(
                    primary: Color(0xFFFFD54F),
                    onPrimary: Colors.white,
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
              backgroundColor: _isDarkMode
                  ? const Color(0xff1e1b24)
                  : Colors.white,
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(
                color: _isDarkMode ? Color(0xfff1c66a) : Colors.black,
              ),
              bodyMedium: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
              titleMedium: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(
                color: _isDarkMode ? Color(0xfff1c66a) : Colors.black,
              ),
              hintStyle: TextStyle(
                color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _isDarkMode
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
    final Color currentScaffoldBg = _isDarkMode
        ? const Color(0xff121212)
        : const Color(0xfffdfbfe);
    final Color currentCardBg = _isDarkMode
        ? const Color(0xff1e1b24)
        : Colors.white;
    final Color mainTextColor = _isDarkMode
        ? Colors.white
        : const Color(0xff121212);
    final Color subTextColor = _isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[700]!;
    final Color borderColor = _isDarkMode
        ? const Color(0xff3d344d)
        : const Color(0xffe1dbec);

    return Scaffold(
      backgroundColor: currentScaffoldBg,
      body: Stack(
        children: [
          Positioned(
            top: 31,
            left: -40,
            child: AnimatedBuilder(
              animation: _floatingController,
              builder: (context, child) {
                final double easeValue = Curves.easeInOut.transform(
                  _floatingController.value,
                );
                return Transform.translate(
                  offset: Offset(0, -12 * easeValue),
                  child: Transform.rotate(angle: -0.15, child: child),
                );
              },
              child: _buildFloatingContainer(
                bgColor: _isDarkMode
                    ? const Color(0x2F252030)
                    : const Color.fromARGB(255, 250, 246, 255),
                icon: Icons.diamond_outlined,
                iconColor: _isDarkMode
                    ? const Color(0xff9a82c7)
                    : const Color.fromARGB(255, 215, 192, 255),
              ),
            ),
          ),
          Positioned(
            top: 150,
            bottom: 125,
            left: 25,
            right: 15,
            child: AnimatedBuilder(
              animation: _floatingController,
              builder: (context, child) {
                final double easeValue = Curves.easeInOut.transform(
                  _floatingController.value,
                );
                return Transform.translate(
                  offset: Offset(0, -12 * easeValue),
                  child: Transform.rotate(angle: 0.15, child: child),
                );
              },
              child: Center(
                child: _buildFloatingContainer(
                  bgColor: _isDarkMode
                      ? const Color.fromARGB(29, 58, 53, 37)
                      : const Color.fromARGB(255, 255, 251, 240),
                  icon: Icons.android_outlined,
                  iconColor: _isDarkMode
                      ? const Color.fromARGB(255, 241, 198, 106)
                      : const Color(0xFFFFD54F),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 31,
            right: -40,
            child: AnimatedBuilder(
              animation: _floatingController,
              builder: (context, child) {
                final double easeValue = Curves.easeInOut.transform(
                  _floatingController.value,
                );
                return Transform.translate(
                  offset: Offset(0, -12 * easeValue),
                  child: Transform.rotate(angle: 0.15, child: child),
                );
              },
              child: _buildFloatingContainer(
                bgColor: _isDarkMode
                    ? const Color.fromARGB(101, 34, 34, 34)
                    : const Color.fromARGB(255, 248, 248, 248),
                icon: Icons.water_outlined,
                iconColor: _isDarkMode
                    ? Colors.grey[700]!
                    : const Color(0xFFE0E0E0),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      top: 16.0,
                      right: 24.0,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 4),
                        RichText(
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
                                text: 'Amomimus',
                                style: TextStyle(color: Color(0xff8c72c4)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 609,
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
                            'Ranting? Cool. Crybaby Desperate? We got you. Venting about how much your job or life sucks is exactly why we built this app, so feel free to let off some steam without holding back.\n\n'
                            'But throwing straight-up hate speech, targeted harassment, or bullying someone who is already down? Nah, that\'s a fast pass to getting booted. There is a very clear line between venting your pain and just being a miserable troll.\n\n'
                            '3. We Ain\'t Snitching\n'
                            'Your secrets are safe with us, seriously. We don\'t hoard, package, or sell your real-world data to sketchy advertisers because, honestly, we don\'t even want to know who you actually are.\n\n'
                            'Our database is built to keep things anonymous, meaning what happens in Amomimus stays in Amomimus. Just remember that this trust goes both ways—don\'t abuse the privacy we give you to cause actual harm out there.\n\n'
                            '4. No Shady Business\n'
                            'Do not use this app to sell illegal stuff, promote sketchy crypto scams, or do any back-alley black-market deals. This is a place for your thoughts, not a marketplace for your side hustles or forbidden goods.\n\n'
                            'If we catch you posting links to shady websites or trying to hustle other users under the guise of anonymity, you\'re gone. Go use the dark web or regular classifieds if you\'re looking to run a sketchy operation.\n\n'
                            '5. Don\'t Spam the Feed\n'
                            'Got a lot on your mind? Spill it all out, but don\'t copy-paste the same exact nonsense fifty times in a row. Nobody wants to scroll through a wall of repeated text when they are trying to read real stories.\n\n'
                            'If you have a massive essay to share, break it down or put it in one long post instead of clogging the main feed. Let other ghosts have a turn to speak without having to compete with your spamming spree.\n\n'
                            '6. No Creepy Stalking\n'
                            'If someone shares a deeply personal, heartbreaking, or wild story, just read it, appreciate the raw honesty, and move on. Don\'t go trying to piece together clues to find out who they are in real life like some discount internet detective.\n\n'
                            'Trying to unmask another user completely ruins the safe vibe we are trying to build here. Respect their privacy the same way you want everyone else to respect yours when you are pouring your heart out.\n\n'
                            '7. Own Your Own Drama\n'
                            'Whatever you type on this screen comes directly from your own thumbs, so you better be ready to back it up. If you say something incredibly wild and end up starting a massive internet beef with another ghost, that\'s entirely on you.\n\n'
                            'We aren\'t here to play babysitter or resolve your anonymous petty arguments. Play stupid games, win stupid prizes—just don\'t cry to us when the entire feed turns against your hot take.\n\n'
                            '8. Keep the Vibes Real\n'
                            'This is a dedicated spot for genuine catharsis and raw human emotion, not a stage for building a fake influencer persona. Leave the clout-chasing, fake flexes, and attention-seeking behavior at the door.\n\n'
                            'We don\'t have a like counter or follower metrics for a reason. If you\'re just here to post fake stories for cheap engagement, you\'re missing the point of this app entirely. Keep it authentic or don\'t post at all.\n\n'
                            '9. Respect the Devs\n'
                            'Don\'t try to hack, reverse-engineer, break, or datamine this app just because you think you\'re a tech wizard. We spent countless hours coding this thing and trying to keep it running smoothly on a budget.\n\n'
                            'If you find a bug, be a homie and report it to us instead of trying to exploit it to mess up the system. Don\'t break the matrix just to prove a point, or we will hard-ban your device permanently.\n\n'
                            '10. Click Accept or Roll Out\n'
                            'If you are completely cool with everything we just laid down, smash that checkmark below and let\'s get you into the app. We\'re hyped to have you around as long as you can follow these simple rules.\n\n'
                            'But if you\'re gonna whine about these guidelines or think they\'re way too strict, the exit is right there in the top left corner. No hard feelings, but we only want people who actually respect the vibe.',
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
                              items:
                                  <String>[
                                    'Bahasa',
                                    'English',
                                    '日本語',
                                    'Español',
                                  ].map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
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
                                style: const TextStyle(
                                  color: Color(0xff8c72c4),
                                ),
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
                                controlAffinity:
                                    ListTileControlAffinity.leading,
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
                                value: _isDarkMode,
                                activeThumbColor: const Color(0xff8c72c4),
                                activeTrackColor: const Color(
                                  0xff8c72c4,
                                ).withOpacity(0.4),
                                onChanged: (bool value) {
                                  setState(() {
                                    _isDarkMode = value;
                                  });
                                },
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
                                    print("Gas Aplikasi!");
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff6c52a3),
                              disabledBackgroundColor: _isDarkMode
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
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
