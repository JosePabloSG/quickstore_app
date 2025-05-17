import 'package:flutter/material.dart';
class ColorSelector extends StatelessWidget {
  final String selectedColor;
  final Function(String) onColorSelected;
  const ColorSelector({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });
  @override
  Widget build(BuildContext context) {
    final colorMap = {
      'Pink': Colors.pink,
      'Blue': Colors.blue,
      'Black': Colors.black,
      'Green': Colors.green,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color: $selectedColor',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: colorMap.entries.map((entry) {
            final label = entry.key;
            final color = entry.value;
            final isSelected = selectedColor == label;
            return GestureDetector(
              onTap: () => onColorSelected(label),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(
                    color: isSelected ? Colors.grey : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
