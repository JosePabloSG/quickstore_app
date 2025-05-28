import 'package:dio/dio.dart';
import '../models/review.dart';

class ReviewApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://682f4084f504aa3c70f35128.mockapi.io',
      validateStatus: (status) => status != null && status < 500,
    ),
  );
  Future<List<Review>> fetchReviewsByProductId(String productId) async {
    final response = await _dio.get(
      '/Reviews',
      queryParameters: {'productId': productId},
    );

    if (response.statusCode == 404) {
      return []; // no hay reseñas
    }

    return (response.data as List)
        .map((json) => Review.fromJson(json))
        .toList();
  }
}