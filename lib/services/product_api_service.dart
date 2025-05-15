import 'package:dio/dio.dart';
import '../models/product.dart';

class ProductApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://api.escuelajs.co/api/v1'), 
  );

  Future<List<Product>> fetchProducts() async {
    final response = await _dio.get('/products'); 
    return (response.data as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }

  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
  final response = await _dio.get('/categories/$categoryId/products');
  return (response.data as List)
      .map((json) => Product.fromJson(json))
      .toList();
}

}

