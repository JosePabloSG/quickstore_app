import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;
    final prefs = user?.notificationPreferences ?? NotificationPreferences();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Order Updates'),
            subtitle: const Text('Get notified about your order status'),
            value: prefs.orderUpdates,
            onChanged: (bool value) {
              userProvider.updateNotificationPreferences(
                NotificationPreferences(
                  orderUpdates: value,
                  promotions: prefs.promotions,
                  newProducts: prefs.newProducts,
                  priceAlerts: prefs.priceAlerts,
                ),
              );
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Promotions'),
            subtitle: const Text('Receive special offers and discounts'),
            value: prefs.promotions,
            onChanged: (bool value) {
              userProvider.updateNotificationPreferences(
                NotificationPreferences(
                  orderUpdates: prefs.orderUpdates,
                  promotions: value,
                  newProducts: prefs.newProducts,
                  priceAlerts: prefs.priceAlerts,
                ),
              );
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('New Products'),
            subtitle: const Text('Stay updated with new arrivals'),
            value: prefs.newProducts,
            onChanged: (bool value) {
              userProvider.updateNotificationPreferences(
                NotificationPreferences(
                  orderUpdates: prefs.orderUpdates,
                  promotions: prefs.promotions,
                  newProducts: value,
                  priceAlerts: prefs.priceAlerts,
                ),
              );
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Price Alerts'),
            subtitle: const Text(
              'Get notified when items in your wishlist go on sale',
            ),
            value: prefs.priceAlerts,
            onChanged: (bool value) {
              userProvider.updateNotificationPreferences(
                NotificationPreferences(
                  orderUpdates: prefs.orderUpdates,
                  promotions: prefs.promotions,
                  newProducts: prefs.newProducts,
                  priceAlerts: value,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
