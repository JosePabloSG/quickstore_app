import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickstore_app/models/payment_method.dart';
import 'package:quickstore_app/services/card_service.dart';
import 'package:quickstore_app/utils/card_formatters.dart';

class EditPaymentMethodScreen extends StatefulWidget {
  final PaymentMethod card;

  const EditPaymentMethodScreen({Key? key, required this.card}) : super(key: key);

  @override
  State<EditPaymentMethodScreen> createState() => _EditPaymentMethodScreenState();
}

class _EditPaymentMethodScreenState extends State<EditPaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardHolderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  String _cardType = 'visa';

  final _cardService = CardService();

  @override
  void initState() {
    super.initState();
    final card = widget.card;
    _cardHolderController.text = card.cardHolder;
    _cardNumberController.text = card.cardNumber;
    _expiryDateController.text = card.expiryDate;
    _cvvController.text = card.cvv.toString();
    _cardType = card.cardType;
  }

  Future<void> _saveCard() async {
    if (_formKey.currentState!.validate()) {
      final updatedCard = PaymentMethod(
        id: widget.card.id,
        cardHolder: _cardHolderController.text.trim(),
        cardNumber: _cardNumberController.text.replaceAll(' ', '').trim(),
        expiryDate: _expiryDateController.text.trim(),
        cardType: _cardType,
        email: FirebaseAuth.instance.currentUser?.email ?? '',
        cvv: int.tryParse(_cvvController.text.trim()) ?? 0,
      );

      final result = await _cardService.updatePaymentMethod(updatedCard);
      if (result != null && context.mounted) {
        Navigator.pop(context, result);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating card')),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Card')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _cardHolderController,
                decoration: _decoration('Card Holder'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                decoration: _decoration('Card Number'),
                inputFormatters: [CardNumberFormatter()],
                validator: (value) =>
                    value == null || value.length < 16 ? 'Invalid card number' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryDateController,
                      keyboardType: TextInputType.number,
                      decoration: _decoration('Expiry Date'),
                      inputFormatters: [ExpiryDateFormatter()],
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) return 'Use MM/YY format';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      decoration: _decoration('CVV'),
                      validator: (value) =>
                          value == null || value.length != 3 ? 'Invalid CVV' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _cardType,
                decoration: _decoration('Card Type'),
                items: ['visa', 'mastercard']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t.toUpperCase())))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _cardType = value);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveCard,
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );
}
