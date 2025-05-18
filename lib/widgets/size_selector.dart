import 'package:flutter/material.dart';
class SizeSelector extends StatelessWidget {
  final String selectedSize;
  final List<String> sizes;
  final Function(String) onSizeSelected;
  const SizeSelector({
    super.key,
    required this.selectedSize,
    required this.sizes,
    required this.onSizeSelected,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Size: $selectedSize',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: sizes.map((size) {
            final isSelected = selectedSize == size;
            return GestureDetector(
              onTap: () => onSizeSelected(size),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  size,
                  style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}