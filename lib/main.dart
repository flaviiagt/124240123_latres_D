import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'services/cart_service.dart';
import 'services/session_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); //inisialisasi Hive
  await Hive.openBox(CartService.boxName); //buka box untuk menyimpan data keranjang belanja

  // Cek session: kalau username sudah tersimpan, langsung ke halaman utama
  final username = await SessionService.getUsername();
  runApp(MyApp(isLoggedIn: username != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Awikwok',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const MainPage() : const LoginPage(),
    );
  }
}
