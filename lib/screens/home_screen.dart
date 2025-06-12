import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickstore_app/widgets/popular_product.dart';
import '../providers/product_provider.dart';
import '../providers/category_provider.dart';
import '../widgets/category_menu.dart';
import '../widgets/product_grid_item.dart';
import '../widgets_shimmer/category_menu_shimmer.dart';
import '../widgets_shimmer/product_grid_item_shimmer.dart';
import '../widgets/search_bar.dart';
import '../providers/search_provider.dart';
import '../widgets/search_history_list.dart';
import '../widgets/filter_chips_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      Provider.of<CategoryProvider>(context, listen: false).loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final products = productProvider.products;
    final filteredProducts = productProvider.filteredProducts;
    final popularProducts = products.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 2,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            toolbarHeight: 70,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SearchBarWidget(
                onSearch: (query) {
                  context.read<ProductProvider>().filterProducts(query);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SearchHistoryList(
                onTapHistory: (term) {
                  context.read<SearchProvider>().updateQuery(term);
                  context.read<ProductProvider>().filterProducts(term);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  categoryProvider.isLoading
                      ? const CategoryMenuShimmer()
                      : const CategoryMenu(),
                  const SizedBox(height: 12),
                  const FilterChipsBar(),
                  const SizedBox(height: 20),
                  const Text(
                    'Most Popular',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: popularProducts.length,
                      itemBuilder:
                          (context, index) => PopularProductCard(
                            product: popularProducts[index],
                          ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Just For You',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          productProvider.isLoading
              ? _buildGridShimmer()
              : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        ProductGridItem(product: filteredProducts[index]),
                    childCount: filteredProducts.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3 / 4,
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildGridShimmer() {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (_, __) => const ProductGridItemShimmer(),
        childCount: 6,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3 / 4,
      ),
    );
  }
}
