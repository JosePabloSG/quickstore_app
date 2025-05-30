import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class FilterChipsBar extends StatefulWidget {
  const FilterChipsBar({super.key});

  @override
  State<FilterChipsBar> createState() => _FilterChipsBarState();
}

class _FilterChipsBarState extends State<FilterChipsBar> {
  bool showInStock = false;
  bool showDiscount = false;
  bool showTopRated = false;

  void _applyFilters() {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    provider.setAdvancedFilters(
      onlyInStock: showInStock,
      onlyWithDiscount: showDiscount,
      minRating: showTopRated ? 4.5 : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('En stock'),
            selected: showInStock,
            onSelected: (val) {
              setState(() => showInStock = val);
              _applyFilters();
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Con descuento'),
            selected: showDiscount,
            onSelected: (val) {
              setState(() => showDiscount = val);
              _applyFilters();
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('⭐ 4.5+'),
            selected: showTopRated,
            onSelected: (val) {
              setState(() => showTopRated = val);
              _applyFilters();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
