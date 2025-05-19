import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';

class SearchBarWidget extends StatelessWidget {
  final void Function(String)? onSearch;

  const SearchBarWidget({super.key, this.onSearch});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Row(
      children: [
        //const CircleAvatar(
        // radius: 22,
        // backgroundColor: Colors.white,
        //child: Icon(Icons.menu, color: Colors.blue),
        // ),
        //
        const SizedBox(width: 12),
        Expanded(
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
        ),
      ],
    );
  }
}
