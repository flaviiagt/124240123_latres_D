import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart_service.dart';

class DetailPage extends StatefulWidget {
  final Product product;
  final String username;
  const DetailPage({super.key, required this.product, required this.username});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _qty = 1;

  Future<void> _addToCart() async {
    await CartService.addToCart(widget.username, widget.product, _qty);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.product.title} ($_qty) masuk ke cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(p.thumbnail,
                  height: 220,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported, size: 100)),
            ),
            const SizedBox(height: 16),
            Text(p.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Brand: ${p.brand} | Category: ${p.category}',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text('\$${p.price}',
                style: const TextStyle(
                    fontSize: 22,
                    color: Colors.green,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('⭐ ${p.rating} | Stok: ${p.stock}'),
            const Divider(height: 24),
            const Text('Deskripsi',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(p.description),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      // qty minimal 1
                      onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
                    ),
                    Text('$_qty', style: const TextStyle(fontSize: 18)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      // qty maksimal = stok
                      onPressed:
                          _qty < p.stock ? () => setState(() => _qty++) : null,
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: p.stock > 0 ? _addToCart : null,
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add to Cart'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
