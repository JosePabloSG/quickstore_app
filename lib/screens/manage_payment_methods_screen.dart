import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickstore_app/screens/payment_methods_screen_new.dart';
import 'package:quickstore_app/screens/payments_methods_screen_edit.dart';
import '../models/payment_method.dart';
import '../models/payment.dart';
import '../services/card_service.dart';
import '../services/payment_service.dart';

class ManagePaymentMethodsScreen extends StatefulWidget {
  const ManagePaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  State<ManagePaymentMethodsScreen> createState() =>
      _ManagePaymentMethodsScreenState();
}

class _ManagePaymentMethodsScreenState
    extends State<ManagePaymentMethodsScreen> {
  final CardService _cardService = CardService();
  final PaymentService _paymentService = PaymentService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<PaymentMethod> _paymentMethods = [];
  List<Payment> _payments = [];
  int _selectedCardIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    setState(() => _isLoading = true);
    try {
      final methods = await _cardService.getPaymentMethods();
      _paymentMethods = methods;

      if (_paymentMethods.isNotEmpty) {
        await _loadPaymentsForCard(_paymentMethods[_selectedCardIndex].id);
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading payment methods: $e')),
      );
    }
  }

  Future<void> _loadPaymentsForCard(String cardId) async {
    final list = await _paymentService.getPaymentsForCard(cardId);
    setState(() => _payments = list);
  }

  Future<void> _simulatePayment() async {
    if (_paymentMethods.isEmpty) return;

    final card = _paymentMethods[_selectedCardIndex];
    final amount = (10 + (DateTime.now().millisecond % 100) * 3.7).toDouble();
    final orderNumber = 100000 + DateTime.now().millisecondsSinceEpoch % 99999;

    final newPayment = Payment(
      paymentsMethodId: card.id,
      amount: amount,
      hourDate: DateTime.now(),
      orderNumber: orderNumber,
    );

    final result = await _paymentService.addPayment(
      card.id,
      newPayment,
    ); // 👈 FIX

    if (result != null && mounted) {
      await _loadPaymentsForCard(card.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Simulated payment \$${amount.toStringAsFixed(2)}'),
        ),
      );
    }
  }

  Future<void> _deleteCard(PaymentMethod card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Delete Card',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Are you sure you want to delete this card?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey.shade700,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade400,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -35,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red.shade400,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );

    if (confirmed == true) {
      final success = await _cardService.deletePaymentMethod(card.id);
      if (success && mounted) {
        _loadPaymentMethods();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Card deleted')));
      }
    }
  }

  Future<void> _openAddCardScreen() async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddPaymentMethodScreen()));

    if (result != null) {
      _loadPaymentMethods();
    }
  }

  Future<void> _openEditCardScreen(PaymentMethod card) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => EditPaymentMethodScreen(card: card)),
    );

    if (result != null) {
      _loadPaymentMethods();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Payments Methods',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_paymentMethods.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text('No payment methods added yet'),
                      ),
                    )
                  else ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Payment Methods',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        controller: PageController(viewportFraction: 0.85),
                        itemCount: _paymentMethods.length,
                        onPageChanged: (i) {
                          setState(() => _selectedCardIndex = i);
                          _loadPaymentsForCard(_paymentMethods[i].id);
                        },
                        itemBuilder: (context, index) {
                          final card = _paymentMethods[index];
                          return _buildCreditCard(card);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Payment History',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(child: _buildPaymentHistoryList()),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004CFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _openAddCardScreen,
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Add Card',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildCreditCard(PaymentMethod card) {
    final bool isMastercard = card.cardType.toLowerCase() == 'mastercard';
    final String logoAsset =
        isMastercard
            ? 'assets/Images/Mastercard.svg'
            : 'assets/Images/Visa.svg';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A237E), Color(0xFF0D47A1)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  logoAsset,
                  width: 50,
                  height: 30,
                  colorFilter:
                      isMastercard
                          ? null // No aplicar filtro para Mastercard
                          : const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                ),
              ),
              const Spacer(),
              Text(
                card.maskedCardNumber,
                style: const TextStyle(
                  letterSpacing: 2,
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CARD HOLDER',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          card.cardHolder,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'EXPIRES',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        card.expiryDate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    iconSize: 20,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white12,
                      padding: const EdgeInsets.all(8),
                    ),
                    icon: const Icon(Icons.edit_outlined, color: Colors.white),
                    onPressed: () => _openEditCardScreen(card),
                  ),
                ),
                IconButton(
                  iconSize: 20,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.2),
                    padding: const EdgeInsets.all(8),
                  ),
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                  onPressed: () => _deleteCard(card),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistoryList() {
    return _payments.isEmpty
        ? const Center(
          child: Text(
            'No payments yet.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        )
        : ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemCount: _payments.length,
          itemBuilder: (context, index) {
            final p = _payments[index];
            final formattedDate =
                '${p.hourDate.day}/${p.hourDate.month}/${p.hourDate.year} ${p.hourDate.hour.toString().padLeft(2, '0')}:${p.hourDate.minute.toString().padLeft(2, '0')}';

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.shopping_bag_outlined, color: Colors.white),
              ),
              title: Text(
                'Order #${p.orderNumber}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                formattedDate,
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: Text(
                '-\$${p.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          },
        );
  }
}
