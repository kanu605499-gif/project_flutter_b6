import 'package:flutter/material.dart';

class MyTiles extends StatelessWidget {
  const MyTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListView'),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        titleTextStyle: TextStyle(
          fontSize: 22.7,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.1,
        ),
        foregroundColor: Colors.white,
      ),
      // ListView
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Kolom Pengisian Form
          const TextField(
            decoration: InputDecoration(
              labelText: 'Name: ',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Email: ',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Contact: ',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Address: ',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.home),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(),
          ),

          // --- 5 LISTTILE (RIWAYAT) ---
          const Text(
            "Daftar Pelanggan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21.7),
          ),
          const SizedBox(height: 10),

          _itemTile("Kanu", "Developer", Icons.code),
          _itemTile("Rama", "Database Engineer", Icons.storage),
          _itemTile("Libby", "Graphic Designer", Icons.palette),
          _itemTile("Goby", "UI/UX Researcher", Icons.search),
          _itemTile("Lae", "Project Manager", Icons.assignment_ind),
        ],
      ),
    );
  }

  Widget _itemTile(String title, String sub, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Color.fromARGB(206, 0, 0, 0),
        child: Icon(icon, size: 20, color: Color.fromARGB(255, 255, 255, 255)),
      ),
      title: Text(title),
      subtitle: Text(sub),
      onTap: () {},
    );
  }
}
