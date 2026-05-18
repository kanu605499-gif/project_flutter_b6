import 'package:flutter/material.dart';

// MyGenderOpsi
class MyGenderOpsi extends StatefulWidget {
  const MyGenderOpsi({super.key});

  @override
  State<MyGenderOpsi> createState() => _MyGenderOpsiState();
}

// _MyGenderOpsiState
class _MyGenderOpsiState extends State<MyGenderOpsi>
    with SingleTickerProviderStateMixin {
  bool _kataTersembunyi = false;
  bool _iconWarna = false;
  bool _deskripsiTeks = false;
  bool _isUsernameVisible = true; // State baru untuk visibility username
  String _karakterOpsi = "Character not chosen yet!";
  int _anonCounter = 10;

  // Controller untuk menampung data input username
  final TextEditingController _usernameController = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // AppBar
      appBar: AppBar(
        title: const Text(
          'Create Your Amomim',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          // IconButton
          IconButton(
            icon: Icon(
              _iconWarna ? Icons.favorite : Icons.favorite_border,
              color: _iconWarna ? Colors.red : Colors.grey,
              size: 28,
            ),
            onPressed: () {
              setState(() {
                _iconWarna = !_iconWarna;
              });
            },
          ),
        ],
      ),
      // SingleChildScrollView
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        // Column
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row Pojok Kiri Atas: Menyejajarkan Tombol Informasi & Teks Developer
            Row(
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _kataTersembunyi = !_kataTersembunyi;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6200EE),
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(Icons.info_outline, size: 22),
                  ),
                ),
                if (_kataTersembunyi) ...[
                  const SizedBox(width: 12),
                  const Text(
                    'Welcome to register screen',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.green,
                      fontSize: 15,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 15),

            // KOLOM USERNAME DENGAN FITUR VISIBILITY ON/OFF
            TextField(
              controller: _usernameController,
              obscureText:
                  !_isUsernameVisible, // Menyembunyikan teks sesuai state
              decoration: InputDecoration(
                labelText: 'ANONYMOUS USERNAME',
                hintText: 'Enter your username',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                // Icon mata on/off di pojok kanan dalam textfield
                suffixIcon: IconButton(
                  icon: Icon(
                    _isUsernameVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isUsernameVisible = !_isUsernameVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // KOLOM DISPLAY RANDOM GENERATE NUMBER
            const Text(
              'MATCHMAKING GENERATE NUMBER',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black45,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E24),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Random Generate Username:',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    '#AMM-${(_anonCounter * 73) % 1000}',
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

            // TextButton
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _deskripsiTeks = !_deskripsiTeks;
                  });
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF6200EE),
                  textStyle: const TextStyle(fontSize: 12.5),
                ),
                child: Text(_deskripsiTeks ? 'Hide Me' : 'Tap Me to Know Me'),
              ),
            ),
            if (_deskripsiTeks)
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
                child: Text(
                  'Welcome to Amomimus! :D\nAmomimus is a catharthic medium that allows the user to surf with no use of real identity',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'CHOOSE YOUR AMOMUS AVATAR',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black45,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 24),

            // Column Staggered Pilihan Karakter
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
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
                        label: 'Amo (Diamond)',
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
                          0,
                          (1.0 - _animationController.value) * 8,
                        ),
                        child: child,
                      );
                    },
                    child: buildInkWellCard(
                      icon: Icons.android,
                      iconColor: const Color.fromARGB(255, 255, 255, 255),
                      bgColor: const Color(0xFFFFD54F),
                      label: 'Amom (Robot)',
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
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
                        bgColor: const Color(0xFFE0E0E0),
                        label: 'Ami (Water)',
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

            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _anonCounter += 1; // Ketuk sekali buat nambah 1
                    });
                    print("Ditambah 1 via Tap");
                  },
                  onDoubleTap: () {
                    setState(() {
                      if (_anonCounter > 0)
                        _anonCounter -= 1; // Ketuk 2 kali buat ngurangin 1
                    });
                    print("Dikurang 1 via Double Tap");
                  },
                  onLongPress: () {
                    setState(() {
                      _anonCounter +=
                          3; // Tahan lama buat nambah instan banyak (+5)
                    });
                    print("Ditambah 3 via Hold");
                  },
                  child: Container(
                    width: 170,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tap Me :     $_anonCounter',
                          style: const TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Diganti ke icon counter dinamis / touch
                        const Icon(
                          Icons.touch_app_outlined,
                          color: Color(0xFF6200EE),
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
      // Tetap ada di pojok bawah, bisa lu fungsikan buat aksi submit data nantinya
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Submit Form data Amomim!");
        },
        backgroundColor: const Color(0xFF6200EE),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.arrow_forward, color: Colors.white, size: 28),
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
            });
            print('Your Chosen Amomus');
          },
          borderRadius: BorderRadius.circular(24),
          child: Center(child: Icon(icon, color: iconColor, size: 44)),
        ),
      ),
    );
  }
}
