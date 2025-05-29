class CategoryModel {
  final int id;
  final String name;
  final String image;
  final int? parentId;
  final List<CategoryModel> subcategories;
  final int productCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.parentId,
    this.subcategories = const [],
    this.productCount = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      parentId: json['parentId'],
      subcategories:
          (json['subcategories'] as List?)
              ?.map((e) => CategoryModel.fromJson(e))
              .toList() ??
          [],
      productCount: json['productCount'] ?? 0,
    );
  }
}
