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
import 'tables/family_member_table.dart';
import 'tables/deposit_transaction_table.dart';
import 'tables/meter_photo_table.dart';
import 'tables/auto_bill_setting_table.dart';
import 'tables/notification_setting_table.dart';
import '../../domain/entities/occupancy.dart';

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
    FamilyMembers,
    DepositTransactions,
    MeterPhotos,
    AutoBillSettings,
    NotificationSettings,
  ],
  daos: [LandlordDao, PropertyDao, TenantDao, BillingDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For testing with a custom executor
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 5;

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
        if (from < 2) {
          // Add new tables
          await m.createTable(familyMembers);
          await m.createTable(depositTransactions);
          await m.createTable(meterPhotos);
          await m.createTable(autoBillSettings);
          await m.createTable(notificationSettings);

          // Add new columns to bills
          await m.addColumn(bills, bills.periodStartDate);
          await m.addColumn(bills, bills.periodEndDate);

          // Add new columns to occupancies
          await m.addColumn(occupancies, occupancies.depositStatus);
          await m.addColumn(occupancies, occupancies.depositReceivedDate);
          await m.addColumn(occupancies, occupancies.depositReturnedDate);
          await m.addColumn(occupancies, occupancies.depositReturnedAmount);
        }
        if (from < 3) {
          // Add new tenant profile columns
          await m.addColumn(tenants, tenants.fatherName);
          await m.addColumn(tenants, tenants.age);
          await m.addColumn(tenants, tenants.gender);
          await m.addColumn(tenants, tenants.secondaryPhone);
          await m.addColumn(tenants, tenants.permanentAddressLine);
          await m.addColumn(tenants, tenants.permanentCity);
          await m.addColumn(tenants, tenants.permanentState);
          await m.addColumn(tenants, tenants.permanentPincode);
          await m.addColumn(tenants, tenants.companyName);
          await m.addColumn(tenants, tenants.officeAddress);
          await m.addColumn(tenants, tenants.aadhaarFrontPhotoPath);
          await m.addColumn(tenants, tenants.aadhaarBackPhotoPath);
          await m.addColumn(tenants, tenants.introducerName);
          await m.addColumn(tenants, tenants.introducerAddress);
          await m.addColumn(tenants, tenants.introducerPhone);

          // Add new family member columns
          await m.addColumn(familyMembers, familyMembers.age);
          await m.addColumn(familyMembers, familyMembers.gender);
        }
        if (from < 4) {
          // Migrate family_members from tenant-linked to occupancy-linked
          // This is a major schema change for occupancy-centric architecture

          // Step 1: Create new table with occupancyId
          await customStatement('''
            CREATE TABLE family_members_new (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              occupancy_id INTEGER NOT NULL REFERENCES occupancies(id),
              name TEXT NOT NULL,
              relationship TEXT NOT NULL,
              phone TEXT,
              aadhar_number TEXT,
              age INTEGER,
              gender TEXT,
              created_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now') * 1000)
            )
          ''');

          // Step 2: Migrate existing data - link family members to tenant's
          // most recent (preferably active) occupancy
          await customStatement('''
            INSERT INTO family_members_new 
              (id, occupancy_id, name, relationship, phone, aadhar_number, age, gender, created_at)
            SELECT 
              fm.id,
              COALESCE(
                (SELECT o.id FROM occupancies o 
                 WHERE o.tenant_id = fm.tenant_id 
                 ORDER BY o.is_active DESC, o.move_in_date DESC 
                 LIMIT 1),
                0
              ) as occupancy_id,
              fm.name,
              fm.relationship,
              fm.phone,
              fm.aadhar_number,
              fm.age,
              fm.gender,
              fm.created_at
            FROM family_members fm
            WHERE EXISTS (
              SELECT 1 FROM occupancies o WHERE o.tenant_id = fm.tenant_id
            )
          ''');

          // Step 3: Drop old table and rename new one
          await customStatement('DROP TABLE family_members');
          await customStatement(
            'ALTER TABLE family_members_new RENAME TO family_members',
          );
          await customStatement(
            'ALTER TABLE family_members_new RENAME TO family_members',
          );
        }
        if (from < 5) {
          // Add settlement columns to occupancies
          await m.addColumn(occupancies, occupancies.deductionAmount);
          await m.addColumn(occupancies, occupancies.deductionReason);
          await m.addColumn(occupancies, occupancies.settlementNotes);
          await m.addColumn(occupancies, occupancies.isSettled);
        }
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
