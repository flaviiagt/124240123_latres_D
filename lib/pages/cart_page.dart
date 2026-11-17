import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/cart_service.dart';

class CartPage extends StatelessWidget {
  final String username;
  const CartPage({super.key, required this.username});

  Future<void> _confirmRemove(
      BuildContext context, Map<String, dynamic> item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus produk?'),
        content: Text('Yakin ingin menghapus ${item['title']} dari keranjang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await CartService.removeItem(item['key']);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produk berhasil dihapus dari keranjang')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang Belanja')),
      // Otomatis rebuild setiap isi box Hive berubah (misal item dihapus)
      body: ValueListenableBuilder(
        valueListenable: CartService.box.listenable(),
        builder: (context, _, __) {
          final items = CartService.getItems(username);
          if (items.isEmpty) {
            return const Center(child: Text('Keranjang masih kosong'));
          }
          double total = 0;
          for (final it in items) {
            total += (it['price'] as double) * (it['qty'] as int);
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final it = items[i];
                    return Card(
                      child: ListTile(
                        leading: Image.network(it['thumbnail'],
                            width: 50,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image_not_supported)),
                        title: Text(it['title']),
                        subtitle: Text(
                            'Qty: ${it['qty']} | Harga: \$${(it['price'] * it['qty']).toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmRemove(context, it),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey.shade300))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
