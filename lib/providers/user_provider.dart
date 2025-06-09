import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/address_model.dart';
import '../services/user_service.dart';
import '../services/shipping_address_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  final UserService _userService = UserService();
  final ShippingAddressService _addressService = ShippingAddressService();
  List<Address> _addresses = [];

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  List<Address> get addresses => _addresses;

  Future<void> loadUser() async {
    try {
      _isLoading = true;
      notifyListeners();

      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        _user = await _userService.getUser(firebaseUser.uid);
        await loadAddresses();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAddresses() async {
    try {
      _isLoading = true;
      notifyListeners();

      _addresses = await _addressService.getAddresses();
    } catch (e) {
      // En caso de error, usamos las direcciones almacenadas en el usuario
      if (_user != null) {
        _addresses = _user!.addresses;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phoneNumber,
    String? photoUrl,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_user != null) {
        final updatedUser = _user!.copyWith(
          name: name,
          phoneNumber: phoneNumber,
          photoUrl: photoUrl,
        );
        await _userService.updateUser(updatedUser);
        _user = updatedUser;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAddress(Address address) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Si es dirección por defecto, actualizar las demás direcciones primero
      if (address.isDefault) {
        for (var i = 0; i < _addresses.length; i++) {
          if (_addresses[i].id != address.id && _addresses[i].isDefault) {
            final nonDefaultAddress = Address(
              id: _addresses[i].id,
              street: _addresses[i].street,
              city: _addresses[i].city,
              state: _addresses[i].state,
              zipCode: _addresses[i].zipCode,
              country: _addresses[i].country,
              label: _addresses[i].label,
              isDefault: false,
              email: _addresses[i].email,
            );

            await _addressService.updateAddress(nonDefaultAddress);
            _addresses[i] = nonDefaultAddress;
          }
        }
      }

      // Actualizar en el API
      final updatedAddress = await _addressService.updateAddress(address);

      // Actualizar en la lista local
      final addressIndex = _addresses.indexWhere((a) => a.id == address.id);
      if (addressIndex != -1) {
        _addresses[addressIndex] = updatedAddress;
      } else {
        _addresses.add(updatedAddress);
      }

      // También actualizar en el usuario de Firebase si está disponible
      if (_user != null) {
        final userAddresses = List<Address>.from(_user!.addresses);
        final userAddressIndex = userAddresses.indexWhere(
          (a) => a.id == address.id,
        );

        if (userAddressIndex != -1) {
          userAddresses[userAddressIndex] = updatedAddress;
        } else {
          userAddresses.add(updatedAddress);
        }

        final updatedUser = _user!.copyWith(addresses: userAddresses);
        await _userService.updateUser(updatedUser);
        _user = updatedUser;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAddress(Address address) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Si es dirección por defecto, actualizar las demás direcciones primero
      if (address.isDefault) {
        for (var i = 0; i < _addresses.length; i++) {
          if (_addresses[i].isDefault) {
            final nonDefaultAddress = Address(
              id: _addresses[i].id,
              street: _addresses[i].street,
              city: _addresses[i].city,
              state: _addresses[i].state,
              zipCode: _addresses[i].zipCode,
              country: _addresses[i].country,
              label: _addresses[i].label,
              isDefault: false,
              email: _addresses[i].email,
            );

            await _addressService.updateAddress(nonDefaultAddress);
            _addresses[i] = nonDefaultAddress;
          }
        }
      }

      // Crear en el API
      final createdAddress = await _addressService.createAddress(address);

      // Añadir a la lista local
      _addresses.add(createdAddress);

      // También actualizar en el usuario de Firebase si está disponible
      if (_user != null) {
        final userAddresses = List<Address>.from(_user!.addresses);
        userAddresses.add(createdAddress);

        final updatedUser = _user!.copyWith(addresses: userAddresses);
        await _userService.updateUser(updatedUser);
        _user = updatedUser;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Eliminar del API
      await _addressService.deleteAddress(addressId);

      // Eliminar de la lista local
      _addresses = _addresses.where((a) => a.id != addressId).toList();

      // También eliminar del usuario de Firebase si está disponible
      if (_user != null) {
        final userAddresses = _user!.addresses.where((a) => a.id != addressId).toList();
        final updatedUser = _user!.copyWith(addresses: userAddresses);
        await _userService.updateUser(updatedUser);
        _user = updatedUser;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateNotificationPreferences(
    NotificationPreferences prefs,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_user != null) {
        final updatedUser = _user!.copyWith(notificationPreferences: prefs);
        await _userService.updateUser(updatedUser);
        _user = updatedUser;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePreferences({
    String? language,
    String? currency,
    bool? isDarkMode,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_user != null) {
        final updatedUser = _user!.copyWith(
          preferredLanguage: language,
          preferredCurrency: currency,
          isDarkMode: isDarkMode,
        );
        await _userService.updateUser(updatedUser);
        _user = updatedUser;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
