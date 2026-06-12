import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_flutter_b6/screens/tugas9ui.dart';
import 'package:project_flutter_b6/services/account_manager.dart';
import 'package:project_flutter_b6/models/user_model.dart';
import 'package:project_flutter_b6/data/anonymous_names.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: AmomimusApp1(email: '', realUsername: '')),
  );
}

// MyGenderOpsi
class AmomimusApp1 extends StatefulWidget {
  final String email;
  final String realUsername;

  const AmomimusApp1({super.key, required this.email, required this.realUsername});

  @override
  State<AmomimusApp1> createState() => AmomimusApp1state();
}

// _Amomimusapp1state
class AmomimusApp1state extends State<AmomimusApp1>
    with SingleTickerProviderStateMixin {
  bool _iconWarna = false;
  bool _isCustomName = false; // Tracks if user typed a name manually
  String _karakterOpsi =
      "Character not chosen yet!"; // Diubah jadi non-final agar bisa di-update di setState

  // Controller untuk menampung data input username
  final TextEditingController _usernameController = TextEditingController();
  late AnimationController _animationController;

  String _generatedId = "#AMM-***";

  @override
  void initState() {
    super.initState();
    _usernameController.text = AnonymousNames.getRandomName("Amo");
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final existingIds = Provider.of<AccountManager>(context, listen: false)
          .accounts
          .map((a) => a.amomimusId)
          .toSet();
      setState(() {
        _generatedId = _generateUniqueId(existingIds);
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// Generates a unique Amomimus ID that doesn't collide with existing ones.
  /// Sequence: #AMM-0001 → #AMM-9999, then #AMM-A001 → #AMM-A999, #AMM-B001, etc.
  String _generateUniqueId(Set<String> existingIds) {
    // Try numeric range first: 0001–9999
    for (int i = 1; i <= 9999; i++) {
      final id = '#AMM-${i.toString().padLeft(4, '0')}';
      if (!existingIds.contains(id)) return id;
    }

    // Overflow to alpha range: A001–A999, B001–B999, ..., Z001–Z999
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    for (int l = 0; l < letters.length; l++) {
      for (int i = 1; i <= 999; i++) {
        final id = '#AMM-${letters[l]}${i.toString().padLeft(3, '0')}';
        if (!existingIds.contains(id)) return id;
      }
    }

    // Fallback (should never be reached in practice)
    return '#AMM-X${DateTime.now().millisecondsSinceEpoch % 10000}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Judul Halaman
                      RichText(
                        text: const TextSpan(
                          text: 'Create Your ',
                          style: TextStyle(
                            fontSize:
                                24, // Sedikit disesuaikan ukurannya agar muat row
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000),
                            fontFamily: 'Sans-Serif',
                          ),
                          children: [
                            TextSpan(
                              text: 'Amomimus',
                              style: TextStyle(
                                color: Color(0xff684ca3),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Tombol Hati Easter Egg di pojok kanan atas
                  IconButton(
                    icon: Icon(
                      _iconWarna ? Icons.favorite : Icons.favorite_border,
                      color: _iconWarna ? Colors.red : Colors.grey,
                      size: 26,
                    ),
                    onPressed: () {
                      setState(() {
                        _iconWarna = !_iconWarna;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _usernameController,
                onChanged: (val) {
                  _isCustomName = true;
                },
                decoration: InputDecoration(
                  labelText: 'ANONYMOUS USERNAME',
                  labelStyle: const TextStyle(
                    color: Color(0xff6c52a3),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  hintText: 'Enter your username',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  suffixIcon: Tooltip(
                    message: "Randomize Name",
                    child: IconButton(
                      icon: const Icon(
                        Icons.shuffle,
                        color: Color(0xff684ca3),
                      ),
                      onPressed: () {
                        if (_karakterOpsi == "Character not chosen yet!") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please choose your Amomus Avatar first!"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else {
                          String gender = "Amo";
                          if (_karakterOpsi.endsWith("Amom")) {
                            gender = "Amom";
                          } else if (_karakterOpsi.endsWith("Ami")) {
                            gender = "Ami";
                          } else if (_karakterOpsi.endsWith("Amo")) {
                            gender = "Amo";
                          }
                          setState(() {
                            _usernameController.text = AnonymousNames.getRandomName(gender);
                            _isCustomName = false;
                          });
                        }
                      },
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(218, 162, 9, 1),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // KOLOM DISPLAY RANDOM GENERATE NUMBER
              const Text(
                'AMOMIMUS ID GENERATOR',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E24),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Random Generate ID:',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      _generatedId,
                      style: const TextStyle(
                        color: Color(0xFFFFD54F),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),

              if (_iconWarna)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'You found the easter egg',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 8),

              const SizedBox(height: 8),

              const Text(
                'CHOOSE YOUR AMOMUS AVATAR',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Column Staggered Pilihan Karakter
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _animationController.value * 8),
                            child: child,
                          );
                        },
                        child: buildInkWellCard(
                          icon: Icons.diamond,
                          iconColor: const Color.fromARGB(255, 255, 255, 255),
                          bgColor: const Color(0xFFB388FF),
                          label: 'Amo',
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                            -5,
                            (1.0 - _animationController.value) * 8,
                          ),
                          child: child,
                        );
                      },
                      child: buildInkWellCard(
                        icon: Icons.android,
                        iconColor: const Color.fromARGB(255, 255, 255, 255),
                        bgColor: const Color(0xFFFFD54F),
                        label: 'Amom',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _animationController.value * -8),
                            child: child,
                          );
                        },
                        child: buildInkWellCard(
                          icon: Icons.water,
                          iconColor: const Color.fromARGB(255, 255, 255, 255),
                          bgColor: const Color(0xFF9E9E9E),
                          label: 'Ami',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  _karakterOpsi,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF6200EE),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),


              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool isGenderChosen = _karakterOpsi != "Character not chosen yet!";
          bool isNameEmpty = _usernameController.text.trim().isEmpty;

          if (isNameEmpty || !isGenderChosen) {
            String missingParts = '';
            if (isNameEmpty && !isGenderChosen) {
              missingParts = 'chosen your Amomus Avatar or entered a custom username';
            } else if (!isGenderChosen) {
              missingParts = 'chosen your Amomus Avatar';
            } else if (isNameEmpty) {
              missingParts = 'entered a custom username';
            }

            final proceed = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Color(0xFFFFD54F), size: 28),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Incomplete Selection',
                        style: TextStyle(
                          color: Color(0xff684ca3),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                content: Text(
                  'You haven\'t $missingParts.\n\nYou won\'t be restricted, but you will not have your custom name displayed to you. The system will auto-generate a random one instead. Do you want to proceed?',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff684ca3),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Proceed', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );

            if (proceed != true) {
              return; // Stop if user canceled
            }
          }

          // Parse gender from _karakterOpsi
          String gender = "Amo"; // default
          if (_karakterOpsi.endsWith("Amom")) {
            gender = "Amom";
          } else if (_karakterOpsi.endsWith("Ami")) {
            gender = "Ami";
          } else if (_karakterOpsi.endsWith("Amo")) {
            gender = "Amo";
          }

          final String customNameInput = _usernameController.text.trim();
          String anonymousUsername;
          String? customUsername;

          if (customNameInput.isEmpty) {
            anonymousUsername = AnonymousNames.getRandomName(gender);
            customUsername = null;
          } else if (!_isCustomName) {
            anonymousUsername = customNameInput;
            customUsername = null;
          } else {
            anonymousUsername = AnonymousNames.getRandomName(gender);
            customUsername = customNameInput;
          }

          final String amomimusId = _generatedId;

          // Create user account and save to DB
          final newUser = UserAccount(
            email: widget.email,
            realUsername: widget.realUsername,
            anonymousUsername: anonymousUsername,
            customUsername: customUsername,
            amomimusId: amomimusId,
            gender: gender,
            registrationDate: DateTime.now().toIso8601String(),
            isDemo: true,
          );

          try {
            await Provider.of<AccountManager>(context, listen: false).registerAndLogin(newUser);
          } catch (e) {
            // sqflite is not supported on Flutter Web — log and continue
            print("==== DB SAVE SKIPPED (possibly web): $e ====");
          }

          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AmomimusApp5(),
              ),
            );
          }
        },
        backgroundColor: const Color(0xFF8C72C4),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(
          Icons.keyboard_arrow_right_outlined,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }

  // Helper Widget Card InkWell
  Widget buildInkWellCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String label,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: 110,
      height: 110,
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        elevation: 6,
        shadowColor: Colors.black45,
        child: InkWell(
          onTap: () {
            setState(() {
              _karakterOpsi = "Your chosen Amomus: $label";
              if (!_isCustomName) {
                _usernameController.text = AnonymousNames.getRandomName(label);
              }
            });
            print('Your Chosen Amomus: $label');
          },
          borderRadius: BorderRadius.circular(24),
          child: Center(child: Icon(icon, color: iconColor, size: 44)),
        ),
      ),
    );
  }
}
