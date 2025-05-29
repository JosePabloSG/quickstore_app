import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  final UserService _userService = UserService();

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> loadUser() async {
    try {
      _isLoading = true;
      notifyListeners();

      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        _user = await _userService.getUserById(firebaseUser.uid);
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

      if (_user != null) {
        final addresses = List<Address>.from(_user!.addresses);
        final index = addresses.indexWhere((a) => a.id == address.id);

        if (index != -1) {
          addresses[index] = address;
        } else {
          addresses.add(address);
        }

        if (address.isDefault) {
          for (var i = 0; i < addresses.length; i++) {
            if (i != index && addresses[i].isDefault) {
              addresses[i] = Address(
                id: addresses[i].id,
                street: addresses[i].street,
                city: addresses[i].city,
                state: addresses[i].state,
                zipCode: addresses[i].zipCode,
                country: addresses[i].country,
                label: addresses[i].label,
                isDefault: false,
              );
            }
          }
        }

        final updatedUser = _user!.copyWith(addresses: addresses);
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

      if (_user != null) {
        final addresses =
            _user!.addresses.where((a) => a.id != addressId).toList();
        final updatedUser = _user!.copyWith(addresses: addresses);
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
