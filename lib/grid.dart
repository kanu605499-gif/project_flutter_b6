import 'package:flutter/material.dart';

class MyGrid extends StatelessWidget {
  const MyGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> galleryItems = [
      {
        'image':
            'assets/images/slaughter-to-prevail-coloured-t-shirt-designs-v0-6i2ol05cp30f1.png',
        'label': 'Slaughter to Prevail',
      },
      {'image': 'assets/images/0x1900-000000-80-0-0.jpg', 'label': 'Slipknot'},
      {
        'image': 'assets/images/channels4_profile.jpg',
        'label': '30 Seconds to Mars',
      },
      {'image': 'assets/images/7967698.jpeg', 'label': 'Body Snacther'},
      {
        'image': 'assets/images/ab67616d0000b2739c7b297e578f262a7ac716e2.jpg',
        'label': 'Angelmaker',
      },
      {
        'image': 'assets/images/ab67616d0000b273bee754528c08d5ff6799a1eb.jpg',
        'label': 'Paramore',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('HammerSonic Profile Register'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 148, 32, 32),
        titleTextStyle: TextStyle(
          fontSize: 23.7,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.1,
        ),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Input formulir
              _buildTextField("Nama Lengkap", Icons.person),
              const SizedBox(height: 12),
              _buildTextField("Email", Icons.email),
              const SizedBox(height: 12),
              _buildTextField("Nomor HP", Icons.phone),
              const SizedBox(height: 12),
              _buildTextField("Deskripsi", Icons.description, maxLines: 3),
              const SizedBox(height: 55),

              //Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: galleryItems.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    // Tambah radius pada item/foto pada grid
                    borderRadius: BorderRadius.circular(17),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: const Color.fromARGB(255, 160, 0, 0),
                          child: Image.asset(
                            galleryItems[index]['image']!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.broken_image,
                                  color: Colors.white,
                                ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          color: Colors.black87,
                          child: Text(
                            galleryItems[index]['label']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Mencoba fungsi untuk menggangti warna border
  Widget _buildTextField(String label, IconData icon, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.redAccent),
        prefixIcon: Icon(icon, color: Colors.redAccent),

        filled: true,
        fillColor: const Color.fromARGB(26, 255, 255, 255),

        // Border saat diam
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),

        // Border saat diklik
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
