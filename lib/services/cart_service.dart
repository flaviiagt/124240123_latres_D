import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';

/// Cart disimpan di Hive. Setiap item = 1 Map dengan key "username_idProduk",
/// sehingga cart tiap user terpisah.
class CartService {
  static const String boxName = 'cart';
  static Box get box => Hive.box(boxName);

  static Future<void> addToCart(String username, Product p, int qty) async {
    final key = '${username}_${p.id}';
    final existing = box.get(key);
    int total = qty + (existing != null ? existing['qty'] as int : 0);
    if (total > p.stock) total = p.stock; // jangan melebihi stok

    await box.put(key, {
      'username': username,
      'productId': p.id,
      'title': p.title,
      'price': p.price,
      'thumbnail': p.thumbnail,
      'qty': total,
    });
  }

  /// Ambil semua item milik username tertentu (beserta key-nya)
  static List<Map<String, dynamic>> getItems(String username) {
    final items = <Map<String, dynamic>>[];
    for (final key in box.keys) {
      final value = box.get(key);
      if (value['username'] == username) {
        items.add({...Map<String, dynamic>.from(value), 'key': key});
      }
    }
    return items;
  }

  static Future<void> removeItem(dynamic key) async {
    await box.delete(key);
  }
}
