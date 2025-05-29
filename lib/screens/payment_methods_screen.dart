import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickstore_app/models/product.dart';
import 'package:quickstore_app/providers/buyNow_provider.dart';
import 'package:quickstore_app/providers/cart_provider.dart';
import 'package:quickstore_app/widgets/price_row.dart';

class PaymentScreen extends StatelessWidget {
  final bool fromBuyNow;

  const PaymentScreen({super.key, this.fromBuyNow = false});

  @override
  Widget build(BuildContext context) {
    final buyNow = context.watch<BuyNowProvider>();
    final cart = context.watch<CartProvider>();

    final List<Map<String, dynamic>> items =
        fromBuyNow && buyNow.product != null
            ? [
                {'product': buyNow.product!, 'quantity': buyNow.quantity},
              ]
            : cart.items.values
                .map((e) => {'product': e.product, 'quantity': e.quantity})
                .toList();

    final subtotal = items.fold<double>(0, (sum, item) {
      final product = item['product'] as Product;
      final quantity = item['quantity'] as int;
      return sum + (product.price * quantity);
    });

    const shipping = 5.0;
    final total = subtotal + shipping;

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Information',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('+506 6000 0000'),
                  Text('correo@ejemplo.com'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) {
                  final product = items[index]['product'] as Product;
                  final quantity = items[index]['quantity'] as int;
                  return ListTile(
                    leading: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            product.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5EBFC),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$quantity',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text(product.title),
                    trailing: Text(
                      '\$${(product.price * quantity).toStringAsFixed(2)}',
                    ),
                  );
                },
              ),
            ),
           Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PriceRow(label: 'Subtotal:', value: cart.subtotal),
                      PriceRow(label: 'Costo de envío:',value: cart.shipping),
                      const Divider(height: 24),
                      PriceRow(label:'Total:',value: cart.total, isTotal: true),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Acción de pago

                  if (fromBuyNow) {
                    Provider.of<BuyNowProvider>(context, listen: false).clear();
                  }

                  // Scaffold
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment completed successfully'),
                    ),
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Pay', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
