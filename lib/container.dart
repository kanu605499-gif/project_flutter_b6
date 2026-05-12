import 'package:flutter/material.dart';

class MyContainer0 extends StatelessWidget {
  const MyContainer0({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elejay Profile'), //Nama website toko
        backgroundColor: const Color.fromARGB(255, 21, 100, 238),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
      ),
      // Mencoba untuk menggunakan fungsi SingleChildScrollView agar tidak error 'overflow' jika layar hp kecil
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. Nama Toko
            const Center(
              child: Text(
                'Toko Elektronik Jaya',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 15),

            // 2. Detail Kontak (Email)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.email, color: Colors.blue),
                  SizedBox(width: 10),
                  Text('tokoelejay.co.id'),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 3. Informasi Pendukung (Phone & Location)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Icon(Icons.phone, size: 18),
                  SizedBox(width: 5),
                  Text('+62xx-xxxx-xxxx'),
                  Spacer(),
                  Icon(Icons.location_on, size: 18, color: Colors.red),
                  Text('Jakarta Pusat'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 4. Implementasi penggunaan Expanded
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: const [
                          Text(
                            '1.2k',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Terjual'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: const [
                          Text(
                            '4.8',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Rating'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 5. Slogan Toko
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Toko Elektronik Jaya, menyediakan segala kebutuhan rumah tangga anda, dalam satu ketukan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black87, height: 1.5),
              ),
            ),

            // 6. Visual Branding kecil-kecilan
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(
                  15,
                ), // Membuat sudut melengkung
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                image: const DecorationImage(
                  //Input logo toko dengan menggunakan asset image
                  image: AssetImage('assets/images/Toko_Elektronik_Jaya.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
