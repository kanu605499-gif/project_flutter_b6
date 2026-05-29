import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter_b6/secondlogin.dart';
import 'package:project_flutter_b6/tugas11a.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _showEasterEggBubble = false;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _loadSavedPreferences();
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
    if (_emailErrorMsg != null || _emailController.text.isEmpty) {
      setState(() {
        _emailErrorMsg = _emailController.text.isEmpty
            ? 'Email cannot be empty'
            : _emailErrorMsg;
      });
      return;
    }

    await _saveLoginPreferences();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AmomimusApp3()),
    );
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
                    errorText: null,
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
                        backgroundColor: const Color(0xFFFFD54F),
                        side: const BorderSide(color: Color(0xffeaeaea)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                        shadowColor: Colors.black.withOpacity(0.05),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/Social_Icons.png',
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.g_mobiledata,
                                    color: Color(0xff121212),
                                  );
                                },
                              ),
                            ),
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
                  const SizedBox(height: 20),
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
            labelText: label.toLowerCase().contains('password')
                ? 'Input Your Password Here'
                : 'Input Your Email Here',
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
            floatingLabelStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6200EE),
            ),
            errorText: errorText,
            errorStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color.fromARGB(255, 218, 218, 218),
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
                color: Color.fromRGBO(218, 162, 9, 1),
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
