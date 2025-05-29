import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/category_provider.dart';
import '../providers/view_mode_provider.dart';
import '../widgets/product_grid_item.dart';
import '../widgets/product_list_item.dart';
import '../widgets/category_menu.dart';
import '../widgets_shimmer/product_grid_item_shimmer.dart';
import '../widgets_shimmer/product_list_item_shimmer.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  int itemsPerPage = 10;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final productProvider = context.read<ProductProvider>();
    final categoryProvider = context.read<CategoryProvider>();

    await Future.wait([
      productProvider.fetchProducts(),
      categoryProvider.loadCategories(),
    ]);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !isLoadingMore) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    if (!mounted) return;
    setState(() {
      isLoadingMore = true;
    });

    try {
      final productProvider = context.read<ProductProvider>();
      await productProvider.fetchProducts(page: currentPage + 1);
      if (mounted) {
        setState(() {
          currentPage++;
          isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final viewModeProvider = context.watch<ViewModeProvider>();
    final products = productProvider.filteredProducts;
    final isGrid = viewModeProvider.viewMode == ViewMode.grid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catalog',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isGrid ? Icons.list : Icons.grid_view,
              color: Colors.black,
            ),
            onPressed: () => viewModeProvider.toggleViewMode(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadInitialData();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Categories Section
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const CategoryMenu(),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                    child: Text(
                      'Best Sellers',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: productProvider.popularProducts.length,
                      itemBuilder: (context, index) {
                        final product = productProvider.popularProducts[index];
                        return Container(
                          width: 120,
                          margin: const EdgeInsets.only(right: 12),
                          child: ProductGridItem(product: product),
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                    child: Text(
                      'Recommended For You',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: productProvider.recommendedProducts.length,
                      itemBuilder: (context, index) {
                        final product =
                            productProvider.recommendedProducts[index];
                        return Container(
                          width: 120,
                          margin: const EdgeInsets.only(right: 12),
                          child: ProductGridItem(product: product),
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                    child: Text(
                      'All Products',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Products Grid/List
            productProvider.isLoading
                ? SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isGrid ? 2 : 1,
                      childAspectRatio: isGrid ? 0.75 : 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          isGrid
                              ? const ProductGridItemShimmer()
                              : const ProductListItemShimmer(),
                      childCount: 6,
                    ),
                  ),
                )
                : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver:
                      isGrid
                          ? SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                ),
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              if (index < products.length) {
                                return ProductGridItem(
                                  product: products[index],
                                );
                              }
                              return null;
                            }, childCount: products.length),
                          )
                          : SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              if (index < products.length) {
                                return ProductListItem(
                                  product: products[index],
                                );
                              }
                              return null;
                            }, childCount: products.length),
                          ),
                ),
            if (isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
