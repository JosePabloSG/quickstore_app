import 'package:dio/dio.dart';
import '../models/product.dart';

class ProductApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://682f4084f504aa3c70f35128.mockapi.io'),
  );

  Future<List<Product>> fetchProducts({int page = 1, int limit = 10}) async {
    final response = await _dio.get(
      '/Products',
      queryParameters: {'page': page, 'limit': limit},
    );
    return (response.data as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }

  Future<List<Product>> fetchProductsByCategory(
    int categoryId, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dio.get(
      '/Products',
      queryParameters: {'categoryId': categoryId, 'page': page, 'limit': limit},
    );
    return (response.data as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }

  Future<List<Product>> fetchPopularProducts({int limit = 5}) async {
    final response = await _dio.get(
      '/Products',
      queryParameters: {'sortBy': 'rating', 'order': 'desc', 'limit': limit},
    );
    return (response.data as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }
}
