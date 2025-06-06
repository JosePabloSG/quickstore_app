import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickstore_app/screens/login_email_screen.dart';
import 'package:quickstore_app/services/auth_service.dart';
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
  bool _isLoading = false;

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
    final user = FirebaseAuth.instance.currentUser;
    final productProvider = context.watch<ProductProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final products = productProvider.products;
    final filteredProducts = productProvider.filteredProducts;
    final popularProducts = products.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Padding(padding: EdgeInsets.only(left: 12)),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 30),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              enabled: !_isLoading,
              leading:
                  _isLoading
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.logout),
              title: Text(_isLoading ? 'Cerrando sesión...' : 'Cerrar sesión'),
              onTap: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Confirmar cierre de sesión'),
                        content: const Text(
                          '¿Estás seguro de que deseas cerrar sesión?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Cerrar sesión'),
                          ),
                        ],
                      ),
                );

                if (shouldLogout == true) {
                  try {
                    setState(() => _isLoading = true);

                    // First disable any UI interactions
                    await Future.microtask(() {});

                    // Then sign out
                    await AuthService().signOut();

                    if (!context.mounted) return;

                    // Finally navigate and reset stack
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const LoginEmailScreen(),
                      ),
                      (route) => false,
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Error al cerrar sesión. Intenta de nuevo.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } finally {
                    if (mounted) {
                      setState(() => _isLoading = false);
                    }
                  }
                }
              },
            ),
          ],
        ),
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
              ? SliverToBoxAdapter(child: _buildGridShimmer())
              : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        ProductGridItem(product: filteredProducts[index]),
                    childCount: filteredProducts.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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

  Widget _buildGridView(List products) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        double width = constraints.maxWidth;
        if (width >= 1200) {
          crossAxisCount = 5;
        } else if (width >= 900) {
          crossAxisCount = 4;
        } else if (width >= 600) {
          crossAxisCount = 3;
        }
        return GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductGridItem(product: product);
          },
        );
      },
    );
  }

  Widget _buildGridShimmer() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        double width = constraints.maxWidth;
        if (width >= 1200) {
          crossAxisCount = 5;
        } else if (width >= 900) {
          crossAxisCount = 4;
        } else if (width >= 600) {
          crossAxisCount = 3;
        }
        return GridView.builder(
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (_, __) => const ProductGridItemShimmer(),
        );
      },
    );
  }
}
