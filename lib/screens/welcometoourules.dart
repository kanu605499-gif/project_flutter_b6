import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../language/language_manager.dart';

import 'uii.dart';

class AmomimusApp4 extends StatefulWidget {
  final String email;
  final String realUsername;

  const AmomimusApp4({
    super.key,
    required this.email,
    required this.realUsername,
  });

  @override
  State<AmomimusApp4> createState() => _AmomimusApp4State();
}

class _AmomimusApp4State extends State<AmomimusApp4> {
  int _currentIndex = 0;
  final bool _isDarkMode = false;

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
        email: widget.email,
        realUsername: widget.realUsername,
        isDarkMode: _isDarkMode,
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
            text: _currentIndex == 0 ? '${context.watch<LanguageManager>().getString('privacy')} ' : '${context.watch<LanguageManager>().getString('about')} ',
            style: TextStyle(
              color: mainTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Sans-Serif',
            ),
            children: [
              TextSpan(
                text: _currentIndex == 0 ? context.watch<LanguageManager>().getString('policy') : 'Amomimus',
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
                    DrawerHeader(
                      decoration: const BoxDecoration(color: Color(0xff6c52a3)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.watch<LanguageManager>().getString('center'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.watch<LanguageManager>().getString('support_queries'),
                            style: const TextStyle(
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
                        context.watch<LanguageManager>().getString('help_support'),
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
                        context.watch<LanguageManager>().getString('app_doc'),
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
                        context.watch<LanguageManager>().getString('report_bug_glitch'),
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
                        context.watch<LanguageManager>().getString('contact_dev'),
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
                      title: Text(
                        context.watch<LanguageManager>().getString('exit'),
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.shield_outlined),
            label: context.watch<LanguageManager>().getString('privacy'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.info_outline),
            label: context.watch<LanguageManager>().getString('about'),
          ),
        ],
      ),
    );
  }
}

class AmomimusFormPage extends StatefulWidget {
  final String email;
  final String realUsername;
  final bool isDarkMode;

  const AmomimusFormPage({
    super.key,
    required this.email,
    required this.realUsername,
    required this.isDarkMode,
  });

  @override
  State<AmomimusFormPage> createState() => _AmomimusFormPageState();
}

class _AmomimusFormPageState extends State<AmomimusFormPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatingController;
  bool _hasAcceptedTerms = false;
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
    
    final lang = context.read<LanguageManager>();
    return lang.currentLanguageCode == 'EN'
        ? '$month/$day/$year'
        : '$day/$month/$year';
  }

  Future<void> _pickDate(BuildContext context) async {
    final lang = context.read<LanguageManager>();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      helpText: lang.getString('select_date'),
      cancelText: lang.getString('cancel'),
      confirmText: lang.getString('ok'),
      errorFormatText: lang.getString('error_format'),
      errorInvalidText: lang.getString('error_invalid'),
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
                    text: context.watch<LanguageManager>().getString('terms_of'),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: mainTextColor,
                      fontFamily: 'Sans-Serif',
                    ),
                    children: const [
                      TextSpan(
                        text: 'Amomimus ',
                        style: const TextStyle(color: Color(0xff8c72c4)),
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
                      Text(
                        context.watch<LanguageManager>().getString('privacy_rules_agreement'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff8c72c4),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        context.watch<LanguageManager>().getString('privacy_rules_text'),
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
                          context.watch<LanguageManager>().getString('system_language'),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: mainTextColor,
                          ),
                        ),
                        DropdownButton<String>(
                          value: context.watch<LanguageManager>().dropdownValue,
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
                            if (newValue != null) {
                              context.read<LanguageManager>().setLanguageFromDropdown(newValue);
                            }
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
                          context.watch<LanguageManager>().getString('dob'),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: mainTextColor,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _pickDate(context),
                          icon: Icon(
                            Icons.calendar_month,
                            size: 18,
                            color: _selectedDate != null
                                ? const Color(0xff8c72c4)
                                : Colors.redAccent,
                          ),
                          label: Text(
                            _getFormattedDate(),
                            style: TextStyle(
                              color: _selectedDate != null
                                  ? const Color(0xff8c72c4)
                                  : Colors.redAccent,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: _selectedDate != null
                                  ? borderColor
                                  : Colors.redAccent.withOpacity(0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_selectedDate == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          context.watch<LanguageManager>().getString('dob_required'),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.redAccent.withOpacity(0.8),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    Divider(height: 32, color: borderColor),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: Text(
                              _hasAcceptedTerms
                                  ? context.watch<LanguageManager>().getString('agreement_verified')
                                  : context.watch<LanguageManager>().getString('ready_to_verify'),
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
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: (_hasAcceptedTerms && _selectedDate != null)
                            ? () {
                                // Verify age >= 18
                                final now = DateTime.now();
                                final age =
                                    now.year -
                                    _selectedDate!.year -
                                    ((now.month < _selectedDate!.month ||
                                            (now.month ==
                                                    _selectedDate!.month &&
                                                now.day < _selectedDate!.day))
                                        ? 1
                                        : 0);

                                if (age < 18) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        context.watch<LanguageManager>().getString('age_warning'),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // Data sync & verification passed
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AmomimusApp1(
                                      email: widget.email,
                                      realUsername: widget.realUsername,
                                    ),
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
                          (_hasAcceptedTerms && _selectedDate != null)
                              ? context.watch<LanguageManager>().getString('accept_continue')
                              : _selectedDate == null
                              ? context.watch<LanguageManager>().getString('select_birthday_first')
                              : context.watch<LanguageManager>().getString('accept_terms_first'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: (_hasAcceptedTerms && _selectedDate != null)
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
                  context.watch<LanguageManager>().getString('mobile_app'),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: mainTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.watch<LanguageManager>().getString('app_desc'),
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
                      context.watch<LanguageManager>().getString('developer'),
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
                      context.watch<LanguageManager>().getString('app_version'),
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
