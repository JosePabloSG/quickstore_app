import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const CartScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: onBack,
        ),
        title: Row(
          children: [
            const Text(
              'Cart',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFFE5EBFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${cart.items.length}',
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/Images/cart.png', 
                    width: 180,
                    height: 180,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final item = items[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item.product.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${item.product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => cart.decreaseQuantity(item.product.id),
                                ),
                                Text(item.quantity.toString()),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => cart.increaseQuantity(item.product.id),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => cart.removeFromCart(item.product.id),
                            ),
                          ],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal:', style: TextStyle(fontSize: 16)),
                          Text('\$${cart.subtotal.toStringAsFixed(2)}'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Costo de envío:', style: TextStyle(fontSize: 16)),
                          Text('\$${cart.shipping.toStringAsFixed(2)}'),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${cart.total.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFF004CFF),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
