import 'package:flutter/material.dart';
import 'profile_details_screen.dart';
import 'shipping_address_screen.dart';
import 'manage_payment_methods_screen.dart';
import 'terms_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              _buildNavigationTile(
                context,
                'Profile',
                icon: Icons.arrow_forward_ios,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileDetailsScreen(),
                    ),
                  );
                },
              ),
              _buildNavigationTile(
                context,
                'Shipping Address',
                icon: Icons.arrow_forward_ios,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ShippingAddressScreen(),
                    ),
                  );
                },
              ),
              _buildNavigationTile(
                context,
                'Payment Methods',
                icon: Icons.arrow_forward_ios,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ManagePaymentMethodsScreen(),
                    ),
                  );
                },
              ),
              _buildNavigationTile(
                context,
                'Terms and Conditions',
                icon: Icons.arrow_forward_ios,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TermsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationTile(
    BuildContext context,
    String title, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Icon(icon, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
