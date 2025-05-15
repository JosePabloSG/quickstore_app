import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../providers/product_provider.dart';

class CategoryMenu extends StatelessWidget {
  const CategoryMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final productProvider = context.watch<ProductProvider>();
    final allProducts = productProvider.allProducts;
    final categories = categoryProvider.categories;

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final count = allProducts
              .where((product) => product.categoryId == category.id)
              .length;

          return GestureDetector(
            onTap: () {
              Provider.of<ProductProvider>(context, listen: false)
                  .fetchProductsByCategory(category.id);
              debugPrint('Seleccionaste ${category.name}');
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      category.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.name,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$count productos',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
