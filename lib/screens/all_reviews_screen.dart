import 'package:flutter/material.dart';
import '../models/review.dart';
import '../services/review_api_service.dart';
import '../widgets/rating_stars.dart';

class AllReviewsScreen extends StatelessWidget {
  final String productId;

  const AllReviewsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Reviews'),
      ),
      body: FutureBuilder<List<Review>>(
        future: ReviewApiService().fetchReviewsByProductId(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error.toString()}'),
            );
          }

          final reviews = snapshot.data!;
          if (reviews.isEmpty) {
            return const Center(
              child: Text('No reviews available'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
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
                          Text(review.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          RatingStars(rating: review.rating, reviewCount: 0),
                          const SizedBox(height: 6),
                          Text(review.comment),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}