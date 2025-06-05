import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/product.dart';

class ShareButton extends StatelessWidget {
  final Product product;

  const ShareButton({super.key, required this.product});

  Future<void> _shareProduct(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(product.imageUrl));
      if (response.statusCode != 200) throw Exception("Image download failed");

      final bytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final imageFile = File('${tempDir.path}/${product.id}_image.jpg');
      await imageFile.writeAsBytes(bytes);

      final message = '''
🛍️ Check out this product on QuickStore!

🔸 ${product.title}
💲 Price: \$${product.price.toStringAsFixed(2)}
📃 Description: ${product.description}
🧵 Material: ${product.material}
🌍 Origin: ${product.origin}
⭐ Rating: ${product.rating} (${product.reviews} reviews)
📦 Stock: ${product.stock > 0 ? '${product.stock} available' : 'Out of stock'}

👉 Visit our app or website to learn more!
''';

      await Share.shareXFiles(
        [XFile(imageFile.path)],
        text: message,
        subject: 'New product on QuickStore!',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to share product')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share, color: Colors.black),
      onPressed: () => _shareProduct(context),
    );
  }
}
