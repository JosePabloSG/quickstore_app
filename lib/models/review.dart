class Review {
  final String id;
  final String productId;
  final String name;
  final String avatar;
  final double rating;
  final String comment;

  Review({
    required this.id,
    required this.productId,
    required this.name,
    required this.avatar,
    required this.rating,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      productId: json['productId'],
      name: json['name'],
      avatar: json['avatar'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'],
    );
  }
}