import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'home_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0; //index untuk bottom navigation bar 0= home, 1=profile
  String? _username; //ambil username dari shared preferences, bisa null kalau belum login

  @override
  void initState() { //dipanggil pertama kali pas halaman ini dibuka
    super.initState(); 
    _loadUser();
  }

  Future<void> _loadUser() async {
    final u = await SessionService.getUsername();
    setState(() => _username = u); 
  }

  @override
  Widget build(BuildContext context) {
    if (_username == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator())); //loading dulu pas ambil username dari shared preferences
    }
    final pages = [ //buat list halaman yang mau ditampilin
      HomePage(username: _username!), //butuh username untuk cek siapa yg login
      ProfilePage(username: _username!),
    ];
    return Scaffold( //buat scaffold dengan bottom navigation bar
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
