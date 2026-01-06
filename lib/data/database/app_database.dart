/// Main Drift database definition for RentKhata.
library;

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Tables
import 'tables/landlord_table.dart';
import 'tables/property_table.dart';
import 'tables/room_table.dart';
import 'tables/tenant_table.dart';
import 'tables/custom_field_table.dart';
import 'tables/occupancy_table.dart';
import 'tables/bill_table.dart';
import 'tables/payment_table.dart';
import 'tables/electricity_rate_table.dart';

// DAOs
import 'daos/landlord_dao.dart';
import 'daos/property_dao.dart';
import 'daos/tenant_dao.dart';
import 'daos/billing_dao.dart';

part 'app_database.g.dart';

/// The main database for RentKhata.
@DriftDatabase(
  tables: [
    Landlords,
    Properties,
    Rooms,
    Tenants,
    CustomFields,
    Occupancies,
    Bills,
    Payments,
    ElectricityRates,
  ],
  daos: [
    LandlordDao,
    PropertyDao,
    TenantDao,
    BillingDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For testing with a custom executor
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Insert default electricity rate
        await into(electricityRates).insert(
          ElectricityRatesCompanion.insert(
            ratePerUnit: 7.0,
            effectiveFrom: DateTime.now(),
          ),
        );
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle migrations here as schema evolves
      },
    );
  }

  /// Get the database file path
  static Future<String> getDatabasePath() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    return p.join(dbFolder.path, 'rent_khata.db');
  }
}

/// Open the database connection.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbPath = await AppDatabase.getDatabasePath();
    final file = File(dbPath);
    return NativeDatabase.createInBackground(file);
  });
}
