import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter_b6/amomimusdark.dart';
import 'package:project_flutter_b6/tugas1102.dart';
import 'package:project_flutter_b6/tugas11a.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database/db_helper.dart';
import 'database/models/tugas11_user_register_sql.dart';
import 'database/preference_handler.dart';

void main() {
  runApp(const AmomimusApp2());
}

class AmomimusApp2 extends StatelessWidget {
  const AmomimusApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xfffdfbfe),
        fontFamily: 'Sans-Serif',
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatingController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  String? _emailErrorMsg;
  String? _passwordErrorMsg;
  bool _showEasterEggBubble = false;

  // 🔴 1. VARIABEL BARU UNTUK LIST VIEW
  Future<List<UserModelSql>>? _userListFuture;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _loadSavedPreferences();

    // 🔴 2. PANGGIL DATA PERTAMA KALI SAAT HALAMAN DIBUKA
    _refreshUserList();
  }

  // 🔴 3. FUNGSI BARU UNTUK REFRESH DATA REAL-TIME
  void _refreshUserList() {
    setState(() {
      _userListFuture = DBHelper().getAllUsers();
    });
  }

  Future<void> _loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    setState(() {
      _emailController.text = prefs.getString('savedEmail') ?? '';
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  Future<void> _saveLoginPreferences() async {
    await PreferenceHandler.setLogin(true);
    final prefs = await SharedPreferences.getInstance();

    if (_rememberMe) {
      await prefs.setString('savedEmail', _emailController.text.trim());
    } else {
      await prefs.remove('savedEmail');
    }

    await prefs.setBool('rememberMe', _rememberMe);
    await prefs.setBool('isLoggedIn', true);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _triggerEasterEgg() {
    if (_showEasterEggBubble) return;
    setState(() {
      _showEasterEggBubble = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showEasterEggBubble = false;
        });
      }
    });
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      if (email.isEmpty) {
        _emailErrorMsg = 'Email cannot be empty';
      } else if (!email.contains('@')) {
        _emailErrorMsg = '@ is required.';
      } else {
        _emailErrorMsg = null;
      }

      if (password.isEmpty) {
        _passwordErrorMsg = 'Password cannot be empty';
      } else {
        _passwordErrorMsg = null;
      }
    });

    if (_emailErrorMsg != null || _passwordErrorMsg != null) {
      return;
    }

    final user = await DBHelper().loginUser(email, password);

    if (user != null) {
      await _saveLoginPreferences();
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 🔴 4. MODIFIKASI NAVIGASI SUPAYA OTOMATIS REFRESH PAS BALIK DARI REGISTER
  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AmomimusApp3()),
    ).then((_) {
      _refreshUserList(); // Sihir pembawa auto-refresh
    });
  }

  void _handleGoogleLogin() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Container(
                width: 140,
                height: 160,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 250, 246, 255),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Icon(
                    Icons.diamond_outlined,
                    size: 48,
                    color: Color.fromARGB(255, 215, 192, 255),
                  ),
                ),
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
                child: Container(
                  width: 140,
                  height: 160,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 251, 240),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.android_outlined,
                      size: 48,
                      color: Color(0xFFFFD54F),
                    ),
                  ),
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
              child: Container(
                width: 140,
                height: 160,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 248, 248, 248),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Icon(
                    Icons.water_outlined,
                    size: 48,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Amomimus',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff684ca3),
                        ),
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              color: Color(0xFFF44336),
                            ),
                            onPressed: _triggerEasterEgg,
                          ),
                          if (_showEasterEggBubble)
                            Positioned(
                              top: 40,
                              right: 0,
                              child: Material(
                                color: Colors.transparent,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF44336),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'You found the easter egg',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textWidthBasis: TextWidthBasis.longestLine,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text: 'Welcome To ',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff121212),
                          fontFamily: 'Sans-Serif',
                        ),
                        children: [
                          TextSpan(
                            text: 'Amomimus',
                            style: TextStyle(color: Color(0xff684ca3)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text:
                            'Amomimus is a cathartic medium that allows users to surf with no need for a real identity',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 134, 134, 134),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomInputField(
                    label: 'EMAIL',
                    hintText: 'name@example.com',
                    controller: _emailController,
                    errorText: _emailErrorMsg,
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          _emailErrorMsg = null;
                        } else if (!value.contains('@')) {
                          _emailErrorMsg = '@ is required.';
                        } else {
                          _emailErrorMsg = null;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    label: 'PASSWORD',
                    hintText: '••••••••',
                    controller: _passwordController,
                    errorText: _passwordErrorMsg,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                    title: const Text('Remember me'),
                    activeColor: const Color(0xff6c52a3),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6c52a3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: _handleGoogleLogin,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AmomimusDarkTheme.policeLineYellow,
                        side: const BorderSide(color: Color(0xffeaeaea)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 1,
                        shadowColor: Colors.black.withOpacity(0.05),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/Social_Icons.png',
                            width: 20,
                            height: 20,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.g_mobiledata,
                                color: Color(0xff121212),
                                size: 24,
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Continue with Google',
                            style: TextStyle(
                              color: Color(0xff121212),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 21),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign up',
                            style: const TextStyle(
                              color: Color(0xff6c52a3),
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _navigateToSignUp,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Color(0xff6c52a3),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'PRIVACY FIRST',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔴 5. KODE BARU: DI SINI FUTUREBUILDER + LISTVIEW NYA BERADA
                  const SizedBox(height: 30),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'REGISTERED USERS (REAL-TIME)',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  FutureBuilder<List<UserModelSql>>(
                    future: _userListFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final daftarUser = snapshot.data;
                      if (daftarUser == null || daftarUser.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('No users registered in SQLite yet.'),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap:
                            true, // Biar ga crash di dalam SingleChildScrollView
                        physics:
                            const NeverScrollableScrollPhysics(), // Numpang scroll ke parent-nya
                        itemCount: daftarUser.length,
                        itemBuilder: (context, index) {
                          final user = daftarUser[index];
                          return Card(
                            elevation: 1,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            color: const Color(0xfff8f6fc),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Color(0xffe1dbec)),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xff6c52a3),
                                child: Text(
                                  user.fullName?.isNotEmpty == true
                                      ? user.fullName!
                                            .substring(0, 1)
                                            .toUpperCase()
                                      : 'U',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                user.fullName ?? 'No Name',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Email: ${user.email}\nFavorite Character: ${user.favoriteCharacter}',
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final String? errorText;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const CustomInputField({
    super.key,
    required this.label,
    this.errorText,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xff2d2d2d),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color.fromARGB(255, 218, 218, 218),
            ),
            errorText: errorText,
            errorStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
            filled: true,
            fillColor: const Color(0xfff8f6fc),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xffe1dbec)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xff6c52a3),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
