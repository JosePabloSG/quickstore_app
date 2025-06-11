class UserModel {
  final String id;
  final String? name;
  final String email;
  final String? phoneNumber;
  final String? photoUrl;
  final List<Address> addresses;
  final String? preferredLanguage;
  final String? preferredCurrency;
  final NotificationPreferences notificationPreferences;
  final DateTime createdAt;
  final bool isDarkMode;

  UserModel({
    required this.id,
    this.name,
    required this.email,
    this.phoneNumber,
    this.photoUrl,
    this.addresses = const [],
    this.preferredLanguage = 'en',
    this.preferredCurrency = 'USD',
    NotificationPreferences? notificationPreferences,
    required this.createdAt,
    this.isDarkMode = false,
  }) : notificationPreferences =
           notificationPreferences ?? NotificationPreferences();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'addresses': addresses.map((address) => address.toMap()).toList(),
      'preferredLanguage': preferredLanguage,
      'preferredCurrency': preferredCurrency,
      'notificationPreferences': notificationPreferences.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'isDarkMode': isDarkMode,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      photoUrl: map['photoUrl'],
      addresses: List<Address>.from(
        (map['addresses'] ?? []).map((x) => Address.fromMap(x)),
      ),
      preferredLanguage: map['preferredLanguage'] ?? 'en',
      preferredCurrency: map['preferredCurrency'] ?? 'USD',
      notificationPreferences: NotificationPreferences.fromMap(
        map['notificationPreferences'] ?? {},
      ),
      createdAt: DateTime.parse(map['createdAt']),
      isDarkMode: map['isDarkMode'] ?? false,
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    List<Address>? addresses,
    String? preferredLanguage,
    String? preferredCurrency,
    NotificationPreferences? notificationPreferences,
    bool? isDarkMode,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      addresses: addresses ?? this.addresses,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      notificationPreferences:
          notificationPreferences ?? this.notificationPreferences,
      createdAt: createdAt,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

class Address {
  final String id;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? label;
  final String email;

  Address({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.email,
    this.label,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'label': label,
      'email': email,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'],
      street: map['street'],
      city: map['city'],
      state: map['state'],
      zipCode: map['zipCode'],
      country: map['country'],
      label: map['label'],
      email: map['email'] ?? '',
    );
  }
}

class NotificationPreferences {
  final bool orderUpdates;
  final bool promotions;
  final bool newProducts;
  final bool priceAlerts;

  NotificationPreferences({
    this.orderUpdates = true,
    this.promotions = true,
    this.newProducts = true,
    this.priceAlerts = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderUpdates': orderUpdates,
      'promotions': promotions,
      'newProducts': newProducts,
      'priceAlerts': priceAlerts,
    };
  }

  factory NotificationPreferences.fromMap(Map<String, dynamic> map) {
    return NotificationPreferences(
      orderUpdates: map['orderUpdates'] ?? true,
      promotions: map['promotions'] ?? true,
      newProducts: map['newProducts'] ?? true,
      priceAlerts: map['priceAlerts'] ?? true,
    );
  }
}
