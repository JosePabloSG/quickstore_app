import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/payment_method.dart';
import '../models/payment.dart';
import '../services/card_service.dart';
import '../services/payment_service.dart';
import '../providers/buyNow_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/price_row.dart';
import '../widgets/payment_status_dialog.dart';

class PaymentScreen extends StatefulWidget {
  final bool fromBuyNow;

  const PaymentScreen({super.key, this.fromBuyNow = false});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<PaymentMethod> cards = [];
  PaymentMethod? selectedCard;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCards();
  }

  Future<void> loadCards() async {
    final fetched = await CardService().getPaymentMethods();
    setState(() {
      cards = fetched;
      if (cards.isNotEmpty) selectedCard = cards.first;
      isLoading = false;
    });
  }

  Future<void> _pay() async {
    if (selectedCard == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecciona una tarjeta')));
      return;
    }

    final buyNow = context.read<BuyNowProvider>();
    final cart = context.read<CartProvider>();

    final totalAmount = widget.fromBuyNow ? buyNow.total : cart.total;
    final now = DateTime.now();
    final orderNumber = now.millisecondsSinceEpoch;

    final payment = Payment(
      paymentsMethodId: selectedCard!.id,
      amount: totalAmount,
      hourDate: now,
      orderNumber: orderNumber,
    );

    // 👉 Mostrar loader
    await showPaymentStatusDialog(context, PaymentStatus.loading);

    try {
      final saved = await PaymentService().addPayment(
        selectedCard!.id,
        payment,
      );

      // 👉 Cierra el loader
      Navigator.of(context).pop();

      if (saved != null) {
        // 👉 Mostrar éxito
        await showPaymentStatusDialog(context, PaymentStatus.success);

        if (widget.fromBuyNow) {
          buyNow.clear();
        } else {
          cart.clearCart();
        }
      } else {
        throw Exception('Error al guardar el pago');
      }
    } catch (e) {
      // 👉 Cierra el loader
      Navigator.of(context).pop();

      // 👉 Mostrar error
      await showPaymentStatusDialog(context, PaymentStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final buyNow = context.watch<BuyNowProvider>();
    final cart = context.watch<CartProvider>();

    final List<Map<String, dynamic>> items =
        widget.fromBuyNow && buyNow.product != null
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
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: items.length,
                                separatorBuilder: (_, __) => const Divider(),
                                itemBuilder: (_, index) {
                                  final product =
                                      items[index]['product'] as Product;
                                  final quantity =
                                      items[index]['quantity'] as int;
                                  return ListTile(
                                    leading: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
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
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFE5EBFC),
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
                              const SizedBox(height: 20),
                              PriceRow(label: 'Subtotal:', value: subtotal),
                              PriceRow(
                                label: 'Costo de envío:',
                                value: shipping,
                              ),
                              const Divider(height: 24),
                              PriceRow(
                                label: 'Total:',
                                value: total,
                                isTotal: true,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Payment Methods',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (cards.isEmpty)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4F4F4),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'No hay tarjetas registradas',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              else
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cards.length,
                                  itemBuilder: (context, index) {
                                    final card = cards[index];
                                    final isSelected = selectedCard == card;

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? Theme.of(
                                                    context,
                                                  ).primaryColor
                                                  : Colors.grey.shade300,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() => selectedCard = card);
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color:
                                                        isSelected
                                                            ? Theme.of(
                                                              context,
                                                            ).primaryColor
                                                            : Colors
                                                                .grey
                                                                .shade300,
                                                    width: 2,
                                                  ),
                                                ),
                                                child:
                                                    isSelected
                                                        ? Center(
                                                          child: Container(
                                                            width: 12,
                                                            height: 12,
                                                            decoration: BoxDecoration(
                                                              shape:
                                                                  BoxShape
                                                                      .circle,
                                                              color:
                                                                  Theme.of(
                                                                    context,
                                                                  ).primaryColor,
                                                            ),
                                                          ),
                                                        )
                                                        : null,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      card.cardHolder,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      card.maskedCardNumber,
                                                      style: TextStyle(
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              const SizedBox(height: 20),
                              PriceRow(label: 'Subtotal:', value: subtotal),
                              PriceRow(
                                label: 'Costo de envío:',
                                value: shipping,
                              ),
                              const Divider(height: 24),
                              PriceRow(
                                label: 'Total:',
                                value: total,
                                isTotal: true,
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _pay,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Pay',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
