import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickstore_app/providers/product_provider.dart';
import 'package:quickstore_app/screens/payments_screen.dart';
import 'package:quickstore_app/widgets/popular_product.dart';
import 'package:quickstore_app/widgets/cart_item_tile.dart';
import 'package:quickstore_app/widgets/price_row.dart';
import '../providers/cart_provider.dart';


class CartScreen extends StatelessWidget {

  final VoidCallback? onBack;
  const CartScreen({super.key, this.onBack});
  
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items.values.toList();
    final productProvider = context.watch<ProductProvider>();
    final popularProducts = productProvider.popularProducts;


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.maybePop(context),
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
                '${cart.totalQuantity}',
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      
      body: items.isEmpty
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/Images/logo.png',
                          width: 180,
                          height: 180,
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Most Popular',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: popularProducts.length,
                      itemBuilder: (context, index) {
                        final product = popularProducts[index];
                        return PopularProductCard(product: product);
                      },
                    ),
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
                      return CartItemTile(
                        item: item,
                        onIncrease: () => cart.increaseQuantity(item.product.id),
                        onDecrease: () => cart.decreaseQuantity(item.product.id),
                        onRemove: () {
                          if (item.quantity == 1) {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.white,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "Remove product from cart",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                                    backgroundColor: Colors.black,
                                                    foregroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    cart.removeFromCart(item.product.id);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Remove"),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  style: ElevatedButton.styleFrom(
                                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                                    backgroundColor: Colors.grey.shade300,
                                                    foregroundColor: Colors.grey.shade600,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                  child: const Text("Cancel"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Positioned(
                                      top: -40,
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xFFFFEAEA),
                                        radius: 35,
                                        child: Icon(
                                          Icons.error_outline,
                                          color: Colors.redAccent,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            cart.removeFromCart(item.product.id);
                          }
                        },
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
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PaymentScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFF004CFF),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
