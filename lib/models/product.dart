class Product {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final int categoryId;
  final double rating;
  final int reviews;


  Product({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.categoryId,
    required this.rating,
    required this.reviews
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      title: json['title'],
      imageUrl: json['images'][0],
      price: (json['price'] as num).toDouble(),
      categoryId: json['category']['id'],
      rating: 4.5,
      reviews: 123,

    );
  }
}
