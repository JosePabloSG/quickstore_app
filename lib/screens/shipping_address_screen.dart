import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';
import 'add_address_screen.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<UserProvider>(context, listen: false).loadUser();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading addresses: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addNewAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddAddressScreen()),
    );
    if (result == true && mounted) _loadAddresses();
  }

  Future<void> _editAddress(Address address) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddAddressScreen(addressToEdit: address),
      ),
    );
    if (result == true && mounted) _loadAddresses();
  }

  Future<void> _deleteAddress(Address address) async {
    final confirmed = await showDialog<bool>(
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
                        'Delete Address',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Are you sure you want to delete this address?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey.shade700,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade400,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
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
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red.shade400,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );

    if (confirmed == true) {
      try {
        setState(() => _isLoading = true);
        await Provider.of<UserProvider>(
          context,
          listen: false,
        ).deleteAddress(address.id);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Address deleted')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error deleting address: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final bool hasNoAddresses = userProvider.addresses.isEmpty;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'My Addresses',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Builder(
                    builder: (context) {
                      if (hasNoAddresses) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF004CFF,
                                  ).withOpacity(0.05),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.location_off_outlined,
                                  size: 64,
                                  color: const Color(
                                    0xFF004CFF,
                                  ).withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'No addresses yet',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add your first shipping address',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        itemCount: userProvider.addresses.length,
                        itemBuilder: (context, index) {
                          final address = userProvider.addresses[index];
                          return AddressCard(
                            address: address,
                            onEdit: () => _editAddress(address),
                            onDelete: () => _deleteAddress(address),
                          );
                        },
                      );
                    },
                  ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _addNewAddress,
            icon: const Icon(Icons.add_location_alt, color: Colors.white),
            label: const Text(
              'Add Address',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: const Color(0xFF004CFF),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          floatingActionButtonLocation:
              hasNoAddresses
                  ? FloatingActionButtonLocation.centerFloat
                  : FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}

class AddressCard extends StatelessWidget {
  final Address address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AddressCard({
    Key? key,
    required this.address,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF004CFF).withOpacity(0.08),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono y línea decorativa
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF004CFF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Color(0xFF004CFF),
                    size: 20,
                  ),
                ),
                Container(
                  width: 2,
                  height: 40,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF004CFF).withOpacity(0.3),
                        const Color(0xFF004CFF).withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Información de la dirección
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.label ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    address.street,
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                  Text(
                    '${address.city}, ${address.state} ${address.zipCode}',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    address.country,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Botones de acción
                  Row(
                    children: [
                      _ActionButton(
                        onTap: onEdit,
                        icon: Icons.edit_outlined,
                        label: 'Edit',
                        color: const Color(0xFF004CFF),
                      ),
                      const SizedBox(width: 12),
                      _ActionButton(
                        onTap: onDelete,
                        icon: Icons.delete_outline_rounded,
                        label: 'Delete',
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final Color color;

  const _ActionButton({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: color.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
