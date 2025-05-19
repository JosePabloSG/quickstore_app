import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickstore_app/screens/login_screen.dart';
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
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
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
                  await AuthService().signOut();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder:
                          (_) => const LoginScreen(showLogoutMessage: true),
                    ),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de búsqueda
              SearchBarWidget(
                onSearch: (query) {
                  context.read<ProductProvider>().filterProducts(query);
                },
              ),
              // Historial de búsqueda
              SearchHistoryList(
                onTapHistory: (term) {
                  context.read<SearchProvider>().updateQuery(term);
                  context.read<ProductProvider>().filterProducts(term);
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              categoryProvider.isLoading
                  ? const CategoryMenuShimmer()
                  : const CategoryMenu(),
              const SizedBox(height: 20),
              const Text(
                'Most Popular',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: popularProducts.length,
                  itemBuilder:
                      (context, index) =>
                          PopularProductCard(product: popularProducts[index]),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Just For You',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child:
                    productProvider.isLoading
                        ? _buildGridShimmer()
                        : _buildGridView(filteredProducts),
              ),
            ],
          ),
        ),
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
