import 'package:quickstore_app/models/address_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? phoneNumber;
  final bool isDarkMode;
  final String preferredLanguage;
  final String preferredCurrency;
  final NotificationPreferences notificationPreferences;
  final DateTime createdAt;
  final List<Address> addresses;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.phoneNumber,
    this.isDarkMode = false,
    this.preferredLanguage = 'en',
    this.preferredCurrency = 'USD',
    NotificationPreferences? notificationPreferences,
    required this.createdAt,
    this.addresses = const [],
  }) : notificationPreferences = notificationPreferences ?? NotificationPreferences();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'isDarkMode': isDarkMode,
      'preferredLanguage': preferredLanguage,
      'preferredCurrency': preferredCurrency,
      'notificationPreferences': notificationPreferences.toJson(),
      'createdAt': Timestamp.fromDate(createdAt),
      'addresses': addresses.map((address) => address.toMap()).toList(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
      phoneNumber: json['phoneNumber'],
      isDarkMode: json['isDarkMode'] ?? false,
      preferredLanguage: json['preferredLanguage'] ?? 'en',
      preferredCurrency: json['preferredCurrency'] ?? 'USD',
      notificationPreferences: json['notificationPreferences'] != null
          ? NotificationPreferences.fromJson(json['notificationPreferences'])
          : null,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      addresses: List<Address>.from(
        (json['addresses'] ?? []).map((x) => Address.fromMap(x)),
      ),
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? phoneNumber,
    bool? isDarkMode,
    String? preferredLanguage,
    String? preferredCurrency,
    NotificationPreferences? notificationPreferences,
    DateTime? createdAt,
    List<Address>? addresses,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      notificationPreferences:
          notificationPreferences ?? this.notificationPreferences,
      createdAt: createdAt ?? this.createdAt,
      addresses: addresses ?? this.addresses,
    );
  }
}

class NotificationPreferences {
  final bool offers;
  final bool orders;
  final bool marketing;

  NotificationPreferences({
    this.offers = false,
    this.orders = false,
    this.marketing = false,
  });

  NotificationPreferences copyWith({
    bool? offers,
    bool? orders,
    bool? marketing,
  }) {
    return NotificationPreferences(
      offers: offers ?? this.offers,
      orders: orders ?? this.orders,
      marketing: marketing ?? this.marketing,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offers': offers,
      'orders': orders,
      'marketing': marketing,
    };
  }

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      offers: json['offers'] ?? false,
      orders: json['orders'] ?? false,
      marketing: json['marketing'] ?? false,
    );
  }
}
