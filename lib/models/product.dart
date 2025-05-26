class Product {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final int categoryId;
  final double rating;
  final int reviews;
  final int stock;
  final bool hasPriceChanged;
  final String material;
  final String origin;
  final String description;

  Product({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.categoryId,
    required this.rating,
    required this.reviews,
    required this.stock,
    required this.material,
    required this.origin,
    required this.description,
    this.hasPriceChanged = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      title: json['title'],
      imageUrl:
          (json['images'] != null && json['images'].isNotEmpty)
              ? json['images'][0]
              : '',
      price: (json['price'] as num).toDouble(),
      categoryId: int.parse(json['categoryId'].toString()),
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'] ?? 0,
      stock: json['stock'] ?? 0,
      material: json['material'] ?? 'Cotton 100%',
      origin: json['origin'] ?? 'Unknown',
      hasPriceChanged: json['hasPriceChanged'] ?? false,
      description: json['description'],
    );
  }
}
