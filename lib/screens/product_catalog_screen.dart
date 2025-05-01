import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_grid_item.dart';
import '../widgets/product_list_item.dart';
import '../providers/view_mode_provider.dart';
import '../providers/product_provider.dart';

class ProductCatalogScreen extends StatelessWidget {
  const ProductCatalogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewMode = context.watch<ViewModeProvider>().viewMode;
    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Productos'),
        actions: [
          IconButton(
            icon: Icon(viewMode == ViewMode.grid ? Icons.view_list : Icons.grid_view),
            tooltip: 'Cambiar vista',
            onPressed: () => context.read<ViewModeProvider>().toggleViewMode(),
          ),
        ],
      ),
      body: viewMode == ViewMode.grid
          ? _buildGridView(products)
          : _buildListView(products),
    );
  }

 Widget _buildGridView(List products) {
  return LayoutBuilder(
    builder: (context, constraints) {
      // Determina cuántas columnas mostrar según el ancho
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
      itemBuilder: (context, index) => ProductListItem(product: products[index]),
    );
  }
}
