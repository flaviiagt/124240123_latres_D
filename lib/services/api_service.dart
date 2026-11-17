import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String _url = 'https://dummyjson.com/products?limit=100';

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['products'];
      return list.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat produk (${response.statusCode})');
    }
  }
}
