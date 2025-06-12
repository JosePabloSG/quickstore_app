import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickstore_app/utils/card_formatters.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/payment_method.dart';
import '../services/card_service.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  final PaymentMethod? existingCard;

  const AddPaymentMethodScreen({super.key, this.existingCard});

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardHolderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  String _cardType = 'visa'; // Default value

  final _cardService = CardService();

  bool _showBackOfCard = false;

  @override
  void initState() {
    super.initState();
    final card = widget.existingCard;
    if (card != null) {
      _cardHolderController.text = card.cardHolder;
      _cardNumberController.text = card.cardNumber;
      _expiryDateController.text = card.expiryDate;
      _cvvController.text = card.cvv.toString();
      _cardType = card.cardType;
    }
  }

  Future<void> _saveCard() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userEmail = user.email ?? '';
      final cleanCardNumber = _cardNumberController.text.replaceAll(' ', '');

      final newCard = PaymentMethod(
        id: widget.existingCard?.id ?? '',
        cardHolder: _cardHolderController.text.trim(),
        cardNumber: cleanCardNumber,
        expiryDate: _expiryDateController.text.trim(),
        cardType: _cardType,
        email: userEmail,
        cvv: int.tryParse(_cvvController.text.trim()) ?? 0,
      );

      // Validar duplicados solo si se está añadiendo, no editando
      if (widget.existingCard == null) {
        final existingCards = await _cardService.getPaymentMethods();
        final isDuplicate = existingCards.any(
          (card) =>
              card.cardNumber.replaceAll(' ', '') == cleanCardNumber &&
              card.email == userEmail,
        );

        if (isDuplicate) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Esta tarjeta ya está registrada.')),
          );
          return;
        }
      }

      final result =
          widget.existingCard != null
              ? await _cardService.updatePaymentMethod(newCard)
              : await _cardService.addPaymentMethod(newCard);

      if (result != null && context.mounted) {
        Navigator.pop(context, result);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error saving card')));
      }
    }
  }

  @override
  void dispose() {
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Card'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Tarjeta de crédito visual
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 200,
                  margin: const EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1A237E), Color(0xFF0D47A1)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: _showBackOfCard ? _buildCardBack() : _buildCardFront(),
                ),

                // Campos de entrada
                TextFormField(
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 18),
                  decoration: _buildInputDecoration(
                    'Card Number',
                    Icons.credit_card,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  validator:
                      (value) =>
                          value == null || value.length < 16
                              ? 'Invalid card number'
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cardHolderController,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(fontSize: 18),
                  decoration: _buildInputDecoration(
                    'Card Holder',
                    Icons.person_outline,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expiryDateController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 18),
                        decoration: _buildInputDecoration(
                          'MM/YY',
                          Icons.date_range,
                        ),
                        inputFormatters: [ExpiryDateFormatter()],
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                            return 'Use MM/YY format';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _cvvController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 18),
                        decoration: _buildInputDecoration(
                          'CVV',
                          Icons.lock_outline,
                        ),
                        onTap: () {
                          setState(() => _showBackOfCard = true);
                        },
                        onEditingComplete: () {
                          setState(() => _showBackOfCard = false);
                        },
                        validator:
                            (value) =>
                                value == null || value.length != 3
                                    ? 'Invalid CVV'
                                    : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _cardType,
                  decoration: _buildInputDecoration(
                    'Card Type',
                    Icons.credit_card,
                  ),
                  items:
                      ['visa', 'mastercard']
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type.toUpperCase()),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _cardType = value);
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _saveCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004CFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save Card',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF004CFF), width: 2),
      ),
    );
  }

  Widget _buildCardFront() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                _cardType.toLowerCase() == 'mastercard'
                    ? 'assets/Images/Mastercard.svg'
                    : 'assets/Images/Visa.svg',
                width: 60,
                height: 40,
                colorFilter: ColorFilter.mode(
                  Colors.white,
                  _cardType.toLowerCase() == 'mastercard'
                      ? BlendMode.dst
                      : BlendMode.srcIn,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            _cardNumberController.text.isEmpty
                ? '**** **** **** ****'
                : _cardNumberController.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CARD HOLDER',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _cardHolderController.text.isEmpty
                        ? 'YOUR NAME'
                        : _cardHolderController.text.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'EXPIRES',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _expiryDateController.text.isEmpty
                        ? 'MM/YY'
                        : _expiryDateController.text,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(height: 50, color: Colors.black26),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: Text(
                _cvvController.text.isEmpty ? '***' : _cvvController.text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ],
    );
  }
}
