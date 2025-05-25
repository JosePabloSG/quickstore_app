import 'package:dio/dio.dart';
import '../models/category_model.dart';

class CategoryApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://682f4084f504aa3c70f35128.mockapi.io'),
  );

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _dio.get('/Categories');
    return (response.data as List)
        .map((json) => CategoryModel.fromJson(json))
        .toList();
  }
}
