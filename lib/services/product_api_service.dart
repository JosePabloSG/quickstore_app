import 'package:dio/dio.dart';
import '../models/product.dart';

class ProductApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://682f4084f504aa3c70f35128.mockapi.io'),
  );

  Future<List<Product>> fetchProducts() async {
    final response = await _dio.get('/Products');
    return (response.data as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }

  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    final response = await _dio.get('/products?categoryId=$categoryId');
    return (response.data as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }
}
