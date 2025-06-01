import 'package:flutter/material.dart';

enum PaymentStatus { loading, success, error }

Future<void> showPaymentStatusDialog(BuildContext context, PaymentStatus status) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      String title = '';
      String message = '';
      IconData icon = Icons.info;
      Color iconColor = Colors.blue;
      List<Widget> actions = [];

      switch (status) {
        case PaymentStatus.loading:
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Payment is in progress'),
                SizedBox(height: 10),
                Text(
                  'Please, wait a few moments',
                  style: TextStyle(fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );

        case PaymentStatus.success:
          title = 'Done!';
          message = 'Your card has been successfully charged';
          icon = Icons.check_circle;
          iconColor = Colors.green;
          actions = [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
                Navigator.of(context).pop(); // go back
              },
              child: const Text('Track My Order'),
            ),
          ];
          break;

        case PaymentStatus.error:
          title = 'We couldn\'t proceed your payment';
          message = 'Please, change your payment method or try again';
          icon = Icons.cancel;
          iconColor = Colors.red;
          actions = [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Try Again'),
            ),
          ];
          break;
      }

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Column(
          children: [
            Icon(icon, size: 50, color: iconColor),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
        content: Text(message, textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: actions,
      );
    },
  );
}



