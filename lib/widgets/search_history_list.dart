import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';

class SearchHistoryList extends StatelessWidget {
  final void Function(String) onTapHistory;

  const SearchHistoryList({super.key, required this.onTapHistory});

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    final history = searchProvider.history;

    //Solo mostrar historial si no hay texto en el campo de búsqueda
    if (!searchProvider.isQueryEmpty || history.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Historial de búsqueda',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => searchProvider.clearHistory(),
              child: const Text('Borrar todo'),
            ),
          ],
        ),
        ...history.map(
          (term) => ListTile(
            title: Text(term),
            leading: const Icon(Icons.history),
            onTap: () => onTapHistory(term),
          ),
        ),
      ],
    );
  }
}
