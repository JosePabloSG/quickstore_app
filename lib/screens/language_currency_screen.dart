import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class LanguageCurrencyScreen extends StatelessWidget {
  const LanguageCurrencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language & Currency'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Language Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Language',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          RadioListTile(
            title: const Text('English'),
            value: 'en',
            groupValue: user?.preferredLanguage,
            onChanged: (value) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Próximamente'),
                  content: const Text('La selección de idioma estará disponible en la próxima actualización.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Entendido'),
                    ),
                  ],
                ),
              );
            },
          ),
          RadioListTile(
            title: const Text('Español'),
            value: 'es',
            groupValue: user?.preferredLanguage,
            onChanged: (value) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Próximamente'),
                  content: const Text('La selección de idioma estará disponible en la próxima actualización.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Entendido'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),

          // Currency Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Currency',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          RadioListTile(
            title: const Text('USD (\$)'),
            value: 'USD',
            groupValue: user?.preferredCurrency,
            onChanged: (value) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Próximamente'),
                  content: const Text('La selección de moneda estará disponible en la próxima actualización.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Entendido'),
                    ),
                  ],
                ),
              );
            },
          ),
          RadioListTile(
            title: const Text('EUR (€)'),
            value: 'EUR',
            groupValue: user?.preferredCurrency,
            onChanged: (value) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Próximamente'),
                  content: const Text('La selección de moneda estará disponible en la próxima actualización.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Entendido'),
                    ),
                  ],
                ),
              );
            },
          ),
          RadioListTile(
            title: const Text('British Pound (GBP)'),
            value: 'GBP',
            groupValue: user?.preferredCurrency,
            onChanged: (value) {
              userProvider.updatePreferences(currency: value);
            },
          ),
        ],
      ),
    );
  }
}
