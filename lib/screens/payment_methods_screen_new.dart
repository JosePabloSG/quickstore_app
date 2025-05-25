import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/payment_method.dart';
import '../services/card_service.dart';
import '../utils/card_formatters.dart';

class ManagePaymentMethodsScreen extends StatefulWidget {
  const ManagePaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  State<ManagePaymentMethodsScreen> createState() =>
      _ManagePaymentMethodsScreenState();
}

class _ManagePaymentMethodsScreenState
    extends State<ManagePaymentMethodsScreen> {
  final CardService _cardService = CardService();
  List<PaymentMethod> _paymentMethods = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final methods = await _cardService.getPaymentMethods();
      setState(() {
        _paymentMethods = methods;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading payment methods: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Methods',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_paymentMethods.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Text(
                    'No payment methods added yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _paymentMethods.length,
                  itemBuilder: (context, index) {
                    final card = _paymentMethods[index];
                    return _buildCreditCard(
                      cardNumber: card.maskedCardNumber,
                      cardHolder: _normalizeName(card.cardHolder),
                      expiryDate: card.expiryDate,
                      cardType: card.cardType,
                      onDelete: () => _showDeleteConfirmation(card),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            _buildAddCardButton(),
          ],
        ),
      ),
    );
  }

  String _normalizeName(String name) {
    if (name.isEmpty) return name;

    // Dividir el nombre en palabras
    List<String> words = name.split(' ');

    // Capitalizar cada palabra
    words =
        words.map((word) {
          if (word.isEmpty) return word;
          // Manejar caracteres especiales y tildes
          String normalized = word.toLowerCase();
          if (normalized.isNotEmpty) {
            normalized = normalized[0].toUpperCase() + normalized.substring(1);
          }
          return normalized;
        }).toList();

    return words.join(' ');
  }

  Widget _buildCreditCard({
    required String cardNumber,
    required String cardHolder,
    required String expiryDate,
    required String cardType,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFFEDF3FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  cardType.toLowerCase() == 'mastercard'
                      ? 'assets/Images/Mastercard.svg'
                      : 'assets/Images/Visa.svg',
                  width: 50,
                  height: 50,
                ),
                const Spacer(),
                Text(
                  cardNumber,
                  style: const TextStyle(
                    fontSize: 16,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      cardHolder,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      expiryDate,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: InkWell(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.more_horiz, color: Colors.black54),
              ),
            ),
          ),
          // Botón de añadir en la esquina derecha
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(16),
                ),
              ),
              child: const Center(
                child: Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCardButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF004CFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => _showAddCardDialog(),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Add Card',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(PaymentMethod card) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Delete Card'),
            content: const Text('Are you sure you want to delete this card?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  final success = await _cardService.deletePaymentMethod(
                    card.id,
                  );
                  if (success && mounted) {
                    _loadPaymentMethods();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Card deleted successfully'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _showAddCardDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Card',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildAddCardForm(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddCardForm() {
    final formKey = GlobalKey<FormState>();
    final cardHolderController = TextEditingController();
    final cardNumberController = TextEditingController();
    final expiryDateController = TextEditingController();
    final cvvController = TextEditingController();

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Card Holder'),
          TextFormField(
            controller: cardHolderController,
            decoration: InputDecoration(
              hintText: 'Name on card',
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the card holder name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text('Card Number'),
          TextFormField(
            controller: cardNumberController,
            decoration: InputDecoration(
              hintText: '1234 5678 9012 3456',
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [CardNumberFormatter()],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the card number';
              }
              final cleanNumber = value.replaceAll(' ', '');
              if (cleanNumber.length != 16) {
                return 'Card number must have 16 digits';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Expiry Date'),
                    TextFormField(
                      controller: expiryDateController,
                      decoration: InputDecoration(
                        hintText: 'MM/YY',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      inputFormatters: [ExpiryDateFormatter()],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (value.length != 5) {
                          return 'Use MM/YY format';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CVV'),
                    TextFormField(
                      controller: cvvController,
                      decoration: InputDecoration(
                        hintText: '123',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (value.length != 3) {
                          return 'Must be 3 digits';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004CFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  String cardType = 'visa';
                  if (cardNumberController.text.startsWith('5')) {
                    cardType = 'mastercard';
                  } else if (cardNumberController.text.startsWith('4')) {
                    cardType = 'visa';
                  }

                  final cleanCardNumber = cardNumberController.text.replaceAll(
                    ' ',
                    '',
                  );

                  final newCard = PaymentMethod(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    cardHolder: cardHolderController.text,
                    cardNumber: cleanCardNumber,
                    expiryDate: expiryDateController.text,
                    cardType: cardType,
                    cvv: cvvController.text,
                  );

                  final addedCard = await _cardService.addPaymentMethod(
                    newCard,
                  );
                  if (addedCard != null && mounted) {
                    Navigator.of(context).pop();
                    _loadPaymentMethods();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Card added successfully')),
                    );
                  } else if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add card')),
                    );
                  }
                }
              },
              child: const Text(
                'Save Card',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
