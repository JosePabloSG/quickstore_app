import 'package:flutter/services.dart';

enum CardType { visa, mastercard, invalid }

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Solo permitir números
    String numbersOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limitar a máximo 4 dígitos (MMYY)
    if (numbersOnly.length > 4) {
      numbersOnly = numbersOnly.substring(0, 4);
    }

    // Insertar el "/"
    String formatted = '';
    for (int i = 0; i < numbersOnly.length; i++) {
      if (i == 2) formatted += '/';
      formatted += numbersOnly[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

