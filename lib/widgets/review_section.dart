import 'package:flutter/material.dart';
import 'package:quickstore_app/screens/all_reviews_screen.dart';
import '../models/review.dart';
import '../services/review_api_service.dart';
import 'rating_stars.dart';

class ReviewSection extends StatefulWidget {
  final String productId;
  const ReviewSection({super.key, required this.productId});

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  late Future<List<Review>> _reviewsFuture;
  @override
  void initState() {
    super.initState();
    _reviewsFuture = ReviewApiService().fetchReviewsByProductId(
      widget.productId,
    );
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Review>>(
      future: _reviewsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          final error = snapshot.error;
          print('Review error: $error');
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Error al cargar reseñas: ${error.toString()}',
              style: const TextStyle(color: Colors.redAccent),
            ),
          );
        }
        final reviews = snapshot.data!;
        if (reviews.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No reviews yet'),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rating & Reviews',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  AllReviewsScreen(productId: widget.productId),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004CFF),
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                      elevation: 4,
                    ),
                    child: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...reviews.take(2).map((review) => _buildReviewItem(review)),
            ],
          ),
        );
      },
    );
  }
  Widget _buildReviewItem(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(review.avatar),
            radius: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                RatingStars(rating: review.rating, reviewCount: 0),
                const SizedBox(height: 6),
                Text(review.comment, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 
