import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickstore_app/utils/card_formatters.dart';
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
        final isDuplicate = existingCards.any((card) =>
            card.cardNumber.replaceAll(' ', '') == cleanCardNumber &&
            card.email == userEmail);

        if (isDuplicate) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Esta tarjeta ya está registrada.')),
          );
          return;
        }
      }

      final result = widget.existingCard != null
          ? await _cardService.updatePaymentMethod(newCard)
          : await _cardService.addPaymentMethod(newCard);

      if (result != null && context.mounted) {
        Navigator.pop(context, result);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error saving card')),
        );
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
    final inputDecoration = (String label) => InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Add Card'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _cardHolderController,
                  decoration: inputDecoration('Card Holder'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  decoration: inputDecoration('Card Number'),
                  validator: (value) =>
                      value == null || value.length < 16
                          ? 'Invalid card number'
                          : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _cardType,
                  decoration: inputDecoration('Card Type'),
                  items: ['visa', 'mastercard']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _cardType = value);
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expiryDateController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Expiry Date',
                          hintText: 'MM/YY',
                        ),
                        inputFormatters: [ExpiryDateFormatter()],
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
                        decoration: inputDecoration('CVV'),
                        validator: (value) =>
                            value == null || value.length != 3
                                ? 'Invalid CVV'
                                : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveCard,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
