import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'database/db_helper.dart';
import 'database/models/tugas11_user_register_sql.dart';
import 'uii.dart';

class AmomimusApp3 extends StatefulWidget {
  const AmomimusApp3({super.key});

  @override
  State<AmomimusApp3> createState() => _AmomimusApp3State();
}

class _AmomimusApp3State extends State<AmomimusApp3>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  late final AnimationController _floatingController;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Widget _buildBounceWrapper({required Widget child}) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        final double wave = math.sin(_floatingController.value * 2 * math.pi);
        return Transform.translate(
          offset: Offset(0, -4 * (wave + 1)),
          child: child,
        );
      },
      child: child,
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: _buildBounceWrapper(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff121212).withOpacity(0.04),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: 'Form ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff6c52a3),
                        letterSpacing: -0.3,
                      ),
                      children: [
                        TextSpan(
                          text: 'Validation',
                          style: TextStyle(
                            color: Color(0xFFFFD54F),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDataTile(
                        'FULL NAME',
                        _nameController.text,
                        valueColor: const Color(0xFFFFD54F),
                      ),
                      const SizedBox(height: 20),
                      _buildDataTile('EMAIL ADDRESS', _emailController.text),
                      const SizedBox(height: 20),
                      _buildDataTile('PASSWORD', '••••••••'),
                      const SizedBox(height: 20),
                      _buildDataTile(
                        'FAVORITE CHARACTER',
                        _cityController.text,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            color: Color(0xff9e9bc2),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD54F),
                          foregroundColor: const Color(0xff121212),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          Navigator.pop(dialogContext);

                          final newUser = UserModelSql(
                            fullName: _nameController.text,
                            email: _emailController.text,
                            favoriteCharacter: _cityController.text,
                            password: _passwordController.text,
                          );

                          bool isSuccess = await DBHelper().registerUser(
                            newUser,
                          );

                          if (context.mounted) {
                            if (isSuccess) {
                              // 2. Kalau BENAR-BENAR sukses masuk DB, baru boleh pindah halaman
                              print("==== REGISTRASI REAL-TIME SUKSES ==== ");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AmomimusApp1(
                                    email: _emailController.text,
                                    realUsername: _nameController.text,
                                  ),
                                ),
                              );
                            } else {
                              // 3. Kalau gagal, tampilin ScaffoldMessenger biar keliatan errornya
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Gagal menyimpan data ke database! Cek log konsol.',
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Lanjut',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: _buildBounceWrapper(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(28.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff121212).withOpacity(0.04),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: 'Registrasi ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff6c52a3),
                        letterSpacing: -0.3,
                      ),
                      children: [
                        TextSpan(
                          text: 'Berhasil',
                          style: TextStyle(
                            color: Color(0xFFFFD54F),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: Color(0xFFFFD54F),
                          size: 80,
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Terima kasih ',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xff9e9bc2),
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: _nameController.text,
                                style: const TextStyle(
                                  color: Color(0xff6c52a3),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const TextSpan(
                                text: ',\nKamu telah terdaftar di sistem kami.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD54F),
                          foregroundColor: const Color(0xff121212),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          Navigator.pop(dialogContext);

                          final newUser = UserModelSql(
                            fullName: _nameController.text,
                            email: _emailController.text,
                            favoriteCharacter: _cityController.text,
                            password: _passwordController.text,
                          );

                          await DBHelper().registerUser(newUser);

                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AmomimusApp1(
                                  email: _emailController.text,
                                  realUsername: _nameController.text,
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Lanjut',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDataTile(
    String label,
    String value, {
    Color valueColor = const Color(0xff6c52a3),
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9E8EB9),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 31,
            left: -40,
            child: _buildAnimatedBox(
              const Color.fromARGB(255, 250, 246, 255),
              Icons.diamond_outlined,
              const Color.fromARGB(255, 215, 192, 255),
              -0.15,
              0.0,
            ),
          ),
          Positioned(
            top: 255,
            left: 25,
            right: 15,
            child: Center(
              child: _buildAnimatedBox(
                const Color.fromARGB(255, 255, 251, 240),
                Icons.android_outlined,
                const Color(0xFFFFD54F),
                0.15,
                math.pi / 2,
              ),
            ),
          ),
          Positioned(
            bottom: 31,
            right: -40,
            child: _buildAnimatedBox(
              const Color(0xFFF8F8F8),
              Icons.water_outlined,
              const Color(0xFFE0E0E0),
              0.15,
              math.pi,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    RichText(
                      text: const TextSpan(
                        text: 'Cooking Your ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff121212),
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
                    CustomInputField(
                      label: 'FULL NAME',
                      hintText: 'Input your full name here',
                      controller: _nameController,
                      validator: (v) => v == null || v.isEmpty
                          ? 'Your name is required'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      label: 'EMAIL',
                      hintText: 'Input your email here',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Your email is required';
                        }
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(v)) {
                          return 'Valid E-mail is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      label: 'PASSWORD',
                      hintText: 'Input your password here',
                      controller: _passwordController,
                      isPassword: true,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Password is required';
                        }
                        if (v.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      label: 'FAVORITE CHARACTER',
                      hintText: 'Who are your favorite character?',
                      controller: _cityController,
                      validator: (v) => v == null || v.isEmpty
                          ? 'Just write anyone brooooo lmao'
                          : null,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _showConfirmationDialog();
                          }
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
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/Social_Icons.png',
                              width: 24,
                              height: 24,
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
                                ..onTap = () => Navigator.pop(context),
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
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBox(
    Color bgColor,
    IconData icon,
    Color iconColor,
    double angle,
    double phaseOffset,
  ) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        final double wave = math.sin(
          (_floatingController.value * 2 * math.pi) + phaseOffset,
        );
        return Transform.translate(
          offset: Offset(0, 10 * wave),
          child: Transform.rotate(angle: angle, child: child),
        );
      },
      child: Container(
        width: 140,
        height: 160,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(child: Icon(icon, size: 48, color: iconColor)),
      ),
    );
  }

  Widget _buildSeparator() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class CustomInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final Color focusedBorderColor;
  final bool isPassword;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.focusedBorderColor = const Color(0xFFFFD54F),
    this.isPassword = false,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xff2d2d2d),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obscureText : false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Color(0xffdadada), fontSize: 14),
            filled: true,
            fillColor: const Color(0xfff8f6fc),
            contentPadding: const EdgeInsets.all(16),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: const Color(0xff9e9bc2),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xffe1dbec)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: widget.focusedBorderColor,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent),
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
