class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String brand;
  final double rating;
  final int stock;
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.brand,
    required this.rating,
    required this.stock,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] ?? '-',
      brand: json['brand'] ?? '-', // beberapa produk tidak punya brand
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: json['stock'] ?? 0,
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}
