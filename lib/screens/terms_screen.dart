import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Last updated: May 17, 2025',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 24),
            Text(
              '1. Introduction\n\n'
              'Welcome to QuickStore! These terms and conditions outline the rules and regulations for the use of our services.\n\n'
              '2. License to use website\n\n'
              'You must not:\n'
              '• Republish material from this website\n'
              '• Sell, rent or sub-license material from this website\n'
              '• Reproduce, duplicate or copy material from this website\n\n'
              '3. Acceptable use\n\n'
              'You must not use this website in any way that causes, or may cause, damage to the website or impairment of the availability or accessibility of the website.\n\n'
              '4. Privacy\n\n'
              'For details about how we collect and use your personal information, please check our Privacy Policy.\n\n'
              '5. Limitations of liability\n\n'
              'We will not be liable to you in relation to the contents of, or use of, or otherwise in connection with, this website.',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
