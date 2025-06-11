import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/user_provider.dart';
import 'profile_details_screen.dart';
import 'shipping_address_screen.dart';
import 'manage_payment_methods_screen.dart';
import 'terms_screen.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Logout'),
              ),
            ],
          ),
    );

    if (shouldLogout == true && context.mounted) {
      try {
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error logging out. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _showComingSoonDialog(
    BuildContext context,
    String feature,
  ) async {
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Coming Soon'),
            content: Text('$feature will be available in future updates.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Widget _buildNavigationTile(
    BuildContext context,
    String title, {
    required IconData icon,
    VoidCallback? onTap,
    Widget? trailing,
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
              style:
                  title == 'Logout'
                      ? const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      )
                      : const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
            ),
            trailing ??
                Icon(
                  icon,
                  size: 16,
                  color: title == 'Logout' ? Colors.red : Colors.grey,
                ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;
    final firebaseUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body:
          userProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  user?.photoUrl != null
                                      ? NetworkImage(user!.photoUrl!)
                                      : null,
                              child:
                                  user?.photoUrl == null
                                      ? const Icon(Icons.person, size: 50)
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user?.name ?? firebaseUser?.email ?? 'Guest',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (user?.email != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                user!.email,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Personal Section
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
                        'Personal Information',
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
                        'Shipping Addresses',
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
                              builder:
                                  (_) => const ManagePaymentMethodsScreen(),
                            ),
                          );
                        },
                      ),

                      // Preferences Section
                      const SizedBox(height: 32),
                      const Text(
                        'Preferences',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildNavigationTile(
                        context,
                        'Language & Currency',
                        icon: Icons.arrow_forward_ios,
                        onTap: () {
                          _showComingSoonDialog(
                            context,
                            'Language and currency settings',
                          );
                        },
                      ),
                      _buildNavigationTile(
                        context,
                        'Notification Settings',
                        icon: Icons.arrow_forward_ios,
                        onTap: () {
                          _showComingSoonDialog(
                            context,
                            'Notification settings',
                          );
                        },
                      ),
                      _buildNavigationTile(
                        context,
                        'Dark Mode',
                        icon: Icons.dark_mode,
                        trailing: Switch(
                          value: userProvider.user?.isDarkMode ?? false,
                          onChanged: (value) {
                            _showComingSoonDialog(context, 'Dark mode');
                          },
                        ),
                      ),

                      // Other Section
                      const SizedBox(height: 32),
                      const Text(
                        'Other',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildNavigationTile(
                        context,
                        'Logout',
                        icon: Icons.logout,
                        onTap: () => _logout(context),
                      ),
                      const SizedBox(height: 16),
                      _buildNavigationTile(
                        context,
                        'Terms and Conditions',
                        icon: Icons.arrow_forward_ios,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TermsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
