import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/product_grid_item.dart';
import '../widgets/product_list_item.dart';
import '../widgets/category_menu.dart';
import '../providers/view_mode_provider.dart';
import '../providers/product_provider.dart';
import '../providers/category_provider.dart';
import '../widgets_shimmer/product_grid_item_shimmer.dart';
import '../widgets_shimmer/product_list_item_shimmer.dart';
import '../widgets_shimmer/category_menu_shimmer.dart';
class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({Key? key}) : super(key: key);
  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}
class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar productos y categorías desde la API
    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      Provider.of<CategoryProvider>(context, listen: false).loadCategories();
    });
  }
  @override
  Widget build(BuildContext context) {
    final viewMode = context.watch<ViewModeProvider>().viewMode;
    final productProvider = context.watch<ProductProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final products = productProvider.products;
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              viewMode == ViewMode.grid ? Icons.view_list : Icons.grid_view,
            ),
            tooltip: 'Cambiar vista',
            onPressed: () => context.read<ViewModeProvider>().toggleViewMode(),
          ),
        ],
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
              title: const Text('Cerrar Sesión'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
    body: Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Categorías',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 8),
      // Carrusel de categorías
      categoryProvider.isLoading
          ? const CategoryMenuShimmer()
          : const CategoryMenu(),
      const SizedBox(height: 20),
      const Text(
        'Just For You',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 8),
      Expanded(
        child: productProvider.isLoading
            ? (viewMode == ViewMode.grid
                ? _buildGridShimmer()
                : _buildListShimmer())
            : (viewMode == ViewMode.grid
                ? _buildGridView(products)
                : _buildListView(products)),
      ),
    ],
  ),
)
  );}
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
          padding: const EdgeInsets.all(8),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 3 / 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) =>
              ProductGridItem(product: products[index]),
        );
      },
    );
  }
  Widget _buildListView(List products) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: products.length,
      itemBuilder: (context, index) =>
          ProductListItem(product: products[index]),
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
          padding: const EdgeInsets.all(8),
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 3 / 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (_, __) => const ProductGridItemShimmer(),
        );
      },
    );
  }
  Widget _buildListShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 6,
      itemBuilder: (_, __) => const ProductListItemShimmer(),
    );
  }
}
