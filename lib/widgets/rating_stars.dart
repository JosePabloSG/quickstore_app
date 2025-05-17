import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const RatingStars({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          if (index < rating.floor()) {
            return const Icon(Icons.star, color: Colors.amber, size: 18);
          } else if (index == rating.floor() && rating % 1 != 0) {
            return const Icon(Icons.star_half, color: Colors.amber, size: 18);
          } else {
            return const Icon(Icons.star_border, color: Colors.amber, size: 18);
          }
        }),
        const SizedBox(width: 6),
        Text(
          '$rating ($reviewCount reviews)',
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }
}
