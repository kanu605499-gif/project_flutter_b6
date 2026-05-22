import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter_b6/welcometoourules.dart';

class AmomimusApp3 extends StatefulWidget {
  const AmomimusApp3({super.key});

  @override
  State<AmomimusApp3> createState() => _AmomimusApp3State();
}

class _AmomimusApp3State extends State<AmomimusApp3>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatingController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _emailErrorMsg;

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
              child: _buildFloatingBox(
                const Color.fromARGB(255, 250, 246, 255),
                Icons.diamond_outlined,
                const Color.fromARGB(255, 215, 192, 255),
              ),
            ),
          ),
          Positioned(
            top: 255,
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
                child: _buildFloatingBox(
                  const Color.fromARGB(255, 255, 251, 240),
                  Icons.android_outlined,
                  const Color(0xFFFFD54F),
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
              child: _buildFloatingBox(
                const Color(0xFFF8F8F8),
                Icons.water_outlined,
                const Color(0xFFE0E0E0),
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
                  // Judul (Tanpa Easter Egg)
                  RichText(
                    text: const TextSpan(
                      text: 'Cooking Your ',
                      style: TextStyle(
                        fontSize: 24,
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
                  const SizedBox(height: 35),

                  const CustomInputField(
                    label: 'ANONYMOUS NAME',
                    hintText: 'Input your anonymous name here',
                  ),
                  const SizedBox(height: 20),

                  CustomInputField(
                    label: 'EMAIL',
                    hintText: 'Input your email here',
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
                    hintText: 'Input your password here',
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey[600],
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: 20),

                  CustomInputField(
                    label: 'CONFIRM PASSWORD',
                    hintText: 'Repeat your password here',
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey[600],
                      ),
                      onPressed: () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AmomimusApp4(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6c52a3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSeparator(),
                  const SizedBox(height: 24),

                  // TOMBOL SIGN UP WITH GOOGLE
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () {},
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
                          Image.asset(
                            'assets/images/Social_Icons.png',
                            width: 20,
                            height: 20,
                            errorBuilder: (c, e, s) =>
                                const Icon(Icons.g_mobiledata),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Sign up with Google',
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
                  const SizedBox(height: 25),

                  // ALREADY HAVE AN ACCOUNT? LOG IN
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Log in',
                            style: const TextStyle(
                              color: Color(0xff6c52a3),
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(
                                  context,
                                ); // Balik ke halaman login
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildFloatingBox(Color bgColor, IconData icon, Color iconColor) {
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

  Widget _buildSeparator() {
    return Row(
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
    );
  }
}

// Custom Input Field bawaan UI Login agar style kotaknya sama persis
class CustomInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final String? errorText;
  final bool obscureText;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    this.errorText,
    this.obscureText = false,
    this.suffixIcon,
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
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            errorText: errorText,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color.fromARGB(255, 218, 218, 218),
              fontSize: 14,
            ),
            filled: true,
            fillColor: const Color(0xfff8f6fc),
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
                color: Color(0xFFDAA209),
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
