import 'package:dio/dio.dart';
import '../models/category_model.dart';

class CategoryApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.escuelajs.co/api/v1'));

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _dio.get('/categories');
    return (response.data as List)
        .map((json) => CategoryModel.fromJson(json))
        .toList();
  }
}
