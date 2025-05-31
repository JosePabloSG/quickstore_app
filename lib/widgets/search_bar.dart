import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';

class SearchBarWidget extends StatelessWidget {
  final void Function(String)? onSearch;

  const SearchBarWidget({super.key, this.onSearch});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ), // <-- Espacio reducido
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  searchProvider.updateQuery(value);
                  if (onSearch != null) onSearch!(value);
                },
                onSubmitted: (value) {
                  searchProvider.addToHistory(value);
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                ),
              ),
            ),
            const Icon(Icons.search, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
