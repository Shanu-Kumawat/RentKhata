/// Core constants for the RentKhata app.
library;

/// Database constants
class DbConstants {
  static const String databaseName = 'rent_khata.db';
  static const int databaseVersion = 1;
}

/// App-wide constants
class AppConstants {
  static const String appName = 'RentKhata';
  static const String defaultCurrency = '₹';
  static const double defaultElectricityRate = 7.0;
}

/// Shared Preferences keys
class PrefKeys {
  static const String isFirstLaunch = 'is_first_launch';
  static const String landlordId = 'landlord_id';
}
