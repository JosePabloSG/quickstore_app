import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickstore_app/models/payment_method.dart';
import 'package:quickstore_app/services/card_service.dart';
import 'package:quickstore_app/utils/card_formatters.dart';
import 'package:quickstore_app/services/payment_method_service.dart';

class EditPaymentMethodScreen extends StatefulWidget {
  final PaymentMethod paymentMethod;

  const EditPaymentMethodScreen({Key? key, required this.paymentMethod}) : super(key: key);

  @override
  State<EditPaymentMethodScreen> createState() => _EditPaymentMethodScreenState();
}

class _EditPaymentMethodScreenState extends State<EditPaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardHolderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _paymentMethodService = PaymentMethodService();
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _cardHolderController.text = widget.paymentMethod.cardHolderName;
    _cardNumberController.text = widget.paymentMethod.cardNumber;
    _expiryDateController.text = widget.paymentMethod.expiryDate;
    _cvvController.text = widget.paymentMethod.cvv;
    _isDefault = widget.paymentMethod.isDefault;
  }

  @override
  void dispose() {
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _savePaymentMethod() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final updatedPaymentMethod = PaymentMethod(
        id: widget.paymentMethod.id,
        cardHolderName: _cardHolderController.text.trim(),
        cardNumber: _cardNumberController.text.trim(),
        expiryDate: _expiryDateController.text.trim(),
        cvv: _cvvController.text.trim(),
        email: widget.paymentMethod.email,
        isDefault: _isDefault,
      );

      await _paymentMethodService.updatePaymentMethod(updatedPaymentMethod);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar método de pago'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _cardHolderController,
              decoration: const InputDecoration(
                labelText: 'Nombre del titular',
                hintText: 'Como aparece en la tarjeta',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el nombre del titular';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cardNumberController,
              decoration: const InputDecoration(
                labelText: 'Número de tarjeta',
                hintText: 'XXXX XXXX XXXX XXXX',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el número de tarjeta';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryDateController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de expiración',
                      hintText: 'MM/YY',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la fecha';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el CVV';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Establecer como predeterminado'),
              value: _isDefault,
              onChanged: (bool value) {
                setState(() {
                  _isDefault = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _savePaymentMethod,
              child: const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
