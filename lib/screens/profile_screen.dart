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
    await Future.delayed(Duration.zero); // evita el setState en build
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Confirm Logout',
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              'Are you sure you want to logout?',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Logout'),
              ),
            ],
          ),
    );

    if (shouldLogout == true && context.mounted) {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _showComingSoonDialog(
    BuildContext context,
    String feature,
  ) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder:
            (context) => Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Coming Soon',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '$feature will be available in future updates.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A237E),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Got it',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -35,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A237E).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.update_rounded,
                          color: Color(0xFF1A237E),
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      );
    });
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _profileTile(
    BuildContext context,
    String label, {
    required IconData icon,
    VoidCallback? onTap,
    Widget? trailing,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color ?? Colors.black54),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w500,
                  color: color ?? Colors.black87,
                ),
              ),
            ),
            trailing ??
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
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
      backgroundColor: const Color(0xFFF2F4F8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    elevation: 2,
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    shadowColor: Colors.black.withOpacity(0.1),
                    title: const Text(
                      'My Profile',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    centerTitle: true,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.shade50,
                                  Colors.blue.shade100,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.blue.shade300,
                                      width: 2,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 42,
                                    backgroundColor: Colors.white,
                                    backgroundImage:
                                        user?.photoUrl != null
                                            ? NetworkImage(user!.photoUrl!)
                                            : null,
                                    child:
                                        user?.photoUrl == null
                                            ? const Icon(
                                              Icons.person,
                                              size: 42,
                                              color: Colors.grey,
                                            )
                                            : null,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  user?.name != null &&
                                          user!.name!.trim().isNotEmpty
                                      ? user.name!
                                      : user?.email ??
                                          firebaseUser?.email ??
                                          'Guest',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                if (user?.name != null &&
                                    user!.name!.trim().isNotEmpty &&
                                    (user.email ?? firebaseUser?.email) != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      user.email ?? firebaseUser?.email ?? '',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          _sectionTitle("Personal"),
                          _profileTile(
                            context,
                            'Personal Information',
                            icon: Icons.person_outline,
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => const ProfileDetailsScreen(),
                                  ),
                                ),
                          ),
                          _profileTile(
                            context,
                            'Shipping Addresses',
                            icon: Icons.location_on_outlined,
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => const ShippingAddressScreen(),
                                  ),
                                ),
                          ),
                          _profileTile(
                            context,
                            'Payment Methods',
                            icon: Icons.credit_card,
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            const ManagePaymentMethodsScreen(),
                                  ),
                                ),
                          ),
                          _sectionTitle("Preferences"),
                          _profileTile(
                            context,
                            'Language & Currency',
                            icon: Icons.language,
                            onTap:
                                () => _showComingSoonDialog(
                                  context,
                                  'Language and Currency',
                                ),
                          ),
                          _profileTile(
                            context,
                            'Notification Settings',
                            icon: Icons.notifications_none,
                            onTap:
                                () => _showComingSoonDialog(
                                  context,
                                  'Notification Settings',
                                ),
                          ),
                          _profileTile(
                            context,
                            'Dark Mode',
                            icon: Icons.dark_mode,
                            trailing: Switch(
                              value: userProvider.user?.isDarkMode ?? false,
                              onChanged:
                                  (val) => _showComingSoonDialog(
                                    context,
                                    'Dark Mode',
                                  ),
                              activeColor: Colors.blue.shade700,
                            ),
                          ),
                          _sectionTitle("Other"),
                          _profileTile(
                            context,
                            'Logout',
                            icon: Icons.logout,
                            color: Colors.red,
                            onTap: () => _logout(context),
                          ),
                          _profileTile(
                            context,
                            'Terms and Conditions',
                            icon: Icons.description_outlined,
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TermsScreen(),
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
