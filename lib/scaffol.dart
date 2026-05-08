import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profil Saya'), // Instruksi: Judul AppBar
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Agar tidak nempel tepi
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Nama: Kanu',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.location_on,
                  color: Color.fromARGB(255, 228, 10, 10),
                ),
                SizedBox(width: 6),
                Text(
                  'West Jakarta, Grogol Pertamburan',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 15),

            const Text(
              'A trainee programmer studying at PPKD Jakarta Pusat, focusing on flutter development.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
