import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/cart_service.dart';
import 'cart_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 72, 22, 223),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text('Happy Shopping, ${widget.username}'),
        actions: [
          ValueListenableBuilder<Box>(
            valueListenable: CartService.box.listenable(),
            builder: (context, _, __) {
              final itemCount = CartService.getItems(widget.username).length;
              return IconButton(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (itemCount > 0)
                      Positioned(
                        top: -8,
                        right: -10,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            itemCount > 99 ? '99+' : '$itemCount',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CartPage(username: widget.username)),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } //loading dulu pas ambil data dari API
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } //kalau ada error pas ambil data dari API
          final products = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: products.length,
            itemBuilder: (context, i) {
              final p = products[i];
              return Card(
                child: ListTile(
                  leading: Image.network(p.thumbnail,
                      width: 56,
                      height: 56,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported)),
                  title: Text(p.title,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('${p.category} | \$${p.price}'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DetailPage(product: p, username: widget.username),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
